with raw as (
  select
  REGEXP_REPLACE(network, r'/\d+$', '') as net,
  CAST(REGEXP_REPLACE(network, r'^\d+\.\d+\.\d+\.\d+/', '') as int64) as mask,
  CAST(case when (-2 + POW(2, 32 - CAST(REGEXP_REPLACE(network, r'^\d+\.\d+\.\d+\.\d+/', '') as int64))) < 1 then 1 else (-2 + POW(2, 32 - CAST(REGEXP_REPLACE(network, r'^\d+\.\d+\.\d+\.\d+/', '') as int64))) end as int64) as hosts,
  * from geoip.tmp_city_ip
), num as (
  select
  NET.IPV4_TO_INT64(NET.IP_FROM_STRING(net)) + 1 as start_num,
  NET.IPV4_TO_INT64(NET.IP_FROM_STRING(net)) + hosts as end_num,
  * from raw
), ip as (
  select
  cast(start_num/(256*256*256) as int64) as class_a,
  NET.IP_TO_STRING(NET.IPV4_FROM_INT64(start_num)) as start_ip,
  NET.IP_TO_STRING(NET.IPV4_FROM_INT64(end_num)) as end_ip,
  * from num
), maxmind AS (
  select
    ip.*,
    l.locale_code, l.continent_code, l.continent_name, l.country_iso_code, l.country_name, l.subdivision_1_iso_code, l.subdivision_1_name, l.subdivision_2_iso_code, l.subdivision_2_name, l.city_name,l.metro_code, l.time_zone, l.is_in_european_union,
    a.autonomous_system_number, a.autonomous_system_organization
  from ip
  left join geoip.tmp_city_labels l on ip.geoname_id = l.geoname_id
  left join geoip.tmp_asn a on ip.network = a.network
)
select * from maxmind
