# kafka stuff

```bash
# Update package list
apt update

# Install build tools and C++ libraries
apt install -y build-essential cmake git wget curl

# Install librdkafka dependencies
apt install -y librdkafka-dev libssl-dev

# Optional: install vim/nano if you want to edit files
apt install -y nano

mkdir kafka_cpp_demo
cd kafka_cpp_demo

# Create producer.cpp
cat << 'EOF' > producer.cpp
#include <iostream>
#include <string>
#include <rdkafkacpp.h>

class ExampleEventCb : public RdKafka::EventCb {
public:
    void event_cb(RdKafka::Event &event) override {
        std::cout << "Event: " << event.str() << std::endl;
    }
};

int main() {
    std::string brokers = "kafka-cluster-kafka-bootstrap.kafka.svc.cluster.local:9092";
    std::string topic_str = "test_topic";

    std::string errstr;
    RdKafka::Conf *conf = RdKafka::Conf::create(RdKafka::Conf::CONF_GLOBAL);
    ExampleEventCb ex_event_cb;
    conf->set("bootstrap.servers", brokers, errstr);
    conf->set("event_cb", &ex_event_cb, errstr);

    RdKafka::Producer *producer = RdKafka::Producer::create(conf, errstr);
    if (!producer) {
        std::cerr << "Failed to create producer: " << errstr << std::endl;
        return 1;
    }

    // Create a topic object
    RdKafka::Topic *topic = RdKafka::Topic::create(producer, topic_str, nullptr, errstr);
    if (!topic) {
        std::cerr << "Failed to create topic: " << errstr << std::endl;
        return 1;
    }

    std::string message = "Hello Kafka!";

    RdKafka::ErrorCode resp = producer->produce(
        topic,
        RdKafka::Topic::PARTITION_UA,
        RdKafka::Producer::RK_MSG_COPY,
        const_cast<char *>(message.c_str()),
        message.size(),
        nullptr,
        nullptr
    );

    if (resp != RdKafka::ERR_NO_ERROR)
        std::cerr << "Produce failed: " << RdKafka::err2str(resp) << std::endl;
    else
        std::cout << "Message sent successfully!" << std::endl;

    producer->flush(5000);

    delete topic;
    delete producer;
    delete conf;
    return 0;
}
EOF

# Create consumer.cpp
cat << 'EOF' > consumer.cpp
#include <iostream>
#include <string>
#include <rdkafkacpp.h>

int main() {
    std::string brokers = "kafka-cluster-kafka-bootstrap.kafka.svc.cluster.local:9092";
    std::string topic_str = "test_topic";
    std::string errstr;

    RdKafka::Conf *conf = RdKafka::Conf::create(RdKafka::Conf::CONF_GLOBAL);
    conf->set("bootstrap.servers", brokers, errstr);
    conf->set("group.id", "example_group", errstr);

    RdKafka::KafkaConsumer *consumer = RdKafka::KafkaConsumer::create(conf, errstr);
    if (!consumer) {
        std::cerr << "Failed to create consumer: " << errstr << std::endl;
        return 1;
    }

    consumer->subscribe({topic_str});

    std::cout << "Waiting for messages..." << std::endl;
    while (true) {
        RdKafka::Message *msg = consumer->consume(1000);
        if (msg->err() == RdKafka::ERR_NO_ERROR) {
            std::cout << "Received: " << std::string(static_cast<char *>(msg->payload()), msg->len()) << std::endl;
        }
        delete msg;
    }

    delete consumer;
    delete conf;
    return 0;
}
EOF

# Compile producer
g++ producer.cpp -o producer -I/usr/include/librdkafka -lrdkafka++ -lrdkafka -std=c++17

# Compile consumer
g++ consumer.cpp -o consumer -I/usr/include/librdkafka -lrdkafka++ -lrdkafka -std=c++17

./producer
./consumer
```
