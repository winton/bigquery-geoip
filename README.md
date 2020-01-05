# bigquery-geoip

Bigquery maxmind geoip loader

## Download GeoLite2

Sign up for an account at <https://maxmind.com>.

Download and extract the following databases:

1. `GeoLite2-ASN-CSV`
2. `GeoLite2-City-CSV`

## Create dataset

```bash
bq mk geoip
```

## Load tables

First, `cd` to the parent directory of the extracted database directories:

```bash
cd ~/Downloads

# These paths should exist:
ls GeoLite2-ASN-CSV*/GeoLite2-ASN-Blocks-IPv4.csv
ls GeoLite2-City-CSV*/GeoLite2-City-Blocks-IPv4.csv
ls GeoLite2-City-CSV*/GeoLite2-City-Locations-en.csv
```

Then run the [load script](bin/load):

```bash
npm install -g bigquery-geoip
bigquery-geoip
```

## Try it out

```sql
with ips as (
  select "162.213.133.27" as ip
)
select city.*, ips.*
from ips
left join geoip.city
  on CAST(NET.IPV4_TO_INT64(NET.IP_FROM_STRING(ips.ip))/(256*256*256) as INT64) = class_a
    and NET.IPV4_TO_INT64(NET.IP_FROM_STRING(ips.ip)) between start_num and end_num
```

## Customize dataset name

The default dataset name is `geoip`. Customize it by adding an argument:

```bash
bigquery-geoip ipToCity
```
