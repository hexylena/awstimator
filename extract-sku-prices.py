import json
import sys


with open(sys.argv[1], 'r') as handle:
    data = json.load(handle)

for sku in sys.stdin:
    sku = sku.strip()
    if sku in data['OnDemand']:
        q = data['OnDemand'][sku]
        w = q.keys()[0]
        e = q[w]['priceDimensions']
        r = e.keys()[0]
        unit = e[r]['unit']
        price = e[r]['pricePerUnit']['USD']

        print('\t'.join((sku, price, unit)))
