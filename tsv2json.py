import csv

ec2_headers = ['mem', 'vcpus', 'name', 'cpu', 'price', 'priceunit']
ec2 = {}

with open('ec2-pricing-final.tsv', 'r') as handle:
    spamreader = csv.reader(handle, delimiter='\t')
    for row in spamreader:
        data = dict(zip(ec2_headers, row[1:]))
        data['mem'] = float(data['mem'].replace(' GiB', ''))
        data['vcpus'] = int(data['vcpus'])
        data['price'] = float(data['price'])

        if data['price'] != 0:
            ec2[row[0]] = data

print(ec2)
