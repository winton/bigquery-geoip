# bigquery-geoip

Bigquery maxmind geoip loader

## Download GeoLite2

Sign up for an account at <maxmind.com>.

Download and extract the following databases:

1. `GeoLite2-ASN-CSV`
2. `GeoLite2-City-CSV`

## Create dataset

```bash
bq mk geoip
```

## Load into bigquery

First, `cd` to the parent directory of the extracted database directories:

```bash
cd ~/Downloads
ls GeoLite2-ASN-CSV* # should exist
ls GeoLite2-City-CSV* # should exist
```

Then run the [load script](bin/load):

```bash
npm install -g bigquery-geoip
bigquery-geoip
```

## Customize dataset name

The default dataset name is `geoip`. Customize it by adding an argument:

```bash
bigquery-geoip ipToCity
```
