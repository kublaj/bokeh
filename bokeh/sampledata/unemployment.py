'''
This modules exposes per-county unemployment data for Unites States in 2009. It exposes a
dictionary 'data' which is indexed by the two-tuple containing (state_id, county_id) and has the
unemployment rate (2009) as the associated value.

'''
import csv
import xml.etree.cElementTree as et
from os.path import dirname, join

data = {}
with open(join(dirname(__file__), 'unemployment09.csv')) as f:
    reader = csv.reader(f, delimiter=',', quotechar='"')
    for row in reader:
        dummy, state_id, county_id, dumm, dummy, dummy, dummy, dummy, rate = row
        data[(int(state_id), int(county_id))] = float(rate)