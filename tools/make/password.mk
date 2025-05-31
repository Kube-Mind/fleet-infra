.PHONY: generate-password generate-erlang-cookie
# openssl rand -base64
# openssl rand: A command from OpenSSL to generate cryptographically secure random bytes.
# -base64: Encodes those 48 bytes as Base64, which expands the output size.
# 48: Generates 48 bytes of random data.

# tr -d '/+='
# tr: A text replacement tool.
# -d '/+=': Deletes the characters /, +, and =, which are common in Base64.

# cut -c1-64
# cut: Extracts specific character ranges from each line.
# -c1-64: Limits output to the first 64 characters.
generate-password:
	@openssl rand -base64 48 | tr -d '/+=' | cut -c1-64

generate-erlang-cookie:
	@openssl rand -base64 32 | tr -d '/+=' | cut -c1-64