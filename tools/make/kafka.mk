.PHONY: kafka-setup kafka-teardown
_KAFKA_PATH = src/workloads/messaging/kafka

kafka-setup:
	$(call kustomize_apply,$(_KAFKA_PATH))
kafka-teardown:
	$(call kustomize_delete,$(_KAFKA_PATH))

.PHONY:  kafka-operator-setup kafka-operator-teardown
kafka-operator-setup:
	$(call kustomize_apply,$(_KAFKA_PATH)/kafka-operator)
kafka-operator-teardown:
	$(call kustomize_delete,$(_KAFKA_PATH)/kafka-operator)