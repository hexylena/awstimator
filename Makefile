all: ec2-pricing-final.tsv

ec2-pricing.json:
	curl https://pricing.us-east-1.amazonaws.com/offers/v1.0/aws/AmazonEC2/current/index.json > ec2-pricing.json


ec2-pricing-frankfurt.tsv:
	cat ec2-pricing.json | \
		jq -r 'select(.attributes.location == "EU (Frankfurt)") | select(.attributes.operatingSystem == "Linux") | select(.productFamily == "Compute Instance") | select(.attributes.tenancy == "Shared") | select(.attributes.instanceFamily == "General purpose") | select(.attributes.preInstalledSw == "NA") | select(.attributes.physicalProcessor | contains("Intel")) | [.sku, .attributes.memory, .attributes.vcpu, .attributes.instanceType, .attributes.physicalProcessor]| @tsv' | \
		sort -k1 \
	> ec2-pricing-frankfurt.tsv


ec2-pricing-terms.json: ec2-pricing.json
	cat ec2-pricing.json | jq '.terms' > ec2-pricing-terms.json

ec2-pricing-terms.tsv: ec2-pricing-frankfurt.tsv ec2-pricing-terms.json
	cat ec2-pricing-frankfurt.tsv | \
		awk '{print $$1}' | \
		python extract-sku-prices.py ec2-pricing-terms.json | \
		sort -k1 \
	> ec2-pricing-terms.tsv

ec2-pricing-final.tsv: ec2-pricing-frankfurt.tsv ec2-pricing-terms.tsv
	join -t "$$(printf '\t')" ec2-pricing-frankfurt.tsv ec2-pricing-terms.tsv > ec2-pricing-final.tsv

ec2-pricing-final.py: ec2-pricing-final.tsv
	python tsv2json.py ec2-pricing-final.tsv > ec2-pricing-final.py
