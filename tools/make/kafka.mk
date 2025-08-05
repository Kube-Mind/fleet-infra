.PHONY: kafka-setup kafka-teardown
kafka-setup:
_KAFKA_PATH = src/workloads/messaging/kafka

kafka-setup:
	$(call kustomize_apply,$(_KAFKA_PATH))
kafka-teardown:
	$(call kustomize_delete,$(_KAFKA_PATH))
