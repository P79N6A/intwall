IMAGE_PREFIX=registry.cn-beijing.aliyuncs.com/intwallyun
IMAGE_NAME=$(IMAGE_PREFIX)/$YOUR_PROJECT_NAME

all:
	docker build -t $(IMAGE_NAME) .
push:
	docker push $(IMAGE_NAME)
clean:
	docker rmi  $(IMAGE_NAME)
	rm -rf build/*