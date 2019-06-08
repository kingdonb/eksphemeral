####################################################################
## Based on Massimo's fantastic https://github.com/mreferre/eksutils
####################################################################

FROM amazonlinux:2018.03
MAINTAINER hausenbl@amazon.com

# set up eksctl and dep IAM authenticator
RUN yum -y install shadow-utils && \
    curl -o aws-iam-authenticator https://amazon-eks.s3-us-west-2.amazonaws.com/1.12.7/2019-03-27/bin/linux/amd64/aws-iam-authenticator && \
    chmod +x ./aws-iam-authenticator && \
    mv ./aws-iam-authenticator /usr/local/bin && \
    curl --silent --location "https://github.com/weaveworks/eksctl/releases/download/latest_release/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp  && \
    mv -v /tmp/eksctl /usr/local/bin

WORKDIR /

RUN /usr/sbin/useradd eksctl

USER eksctl

CMD eksctl create cluster \
    --name $CLUSTER_NAME \
    --version $KUBERNETES_VERSION \
    --nodes $NUM_WORKERS \
    --auto-kubeconfig \
    --full-ecr-access \
    --appmesh-access