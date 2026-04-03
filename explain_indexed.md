Pager usage is off.
Timing is on.
# Indexed Execution Plans

## Q1 — All murders in SQL City
                                                                  QUERY PLAN                                                                  
----------------------------------------------------------------------------------------------------------------------------------------------
 Index Scan using idx_crime_city_type_date on crime_scene_report  (cost=0.28..8.30 rows=1 width=53) (actual time=0.048..0.074 rows=3 loops=1)
   Index Cond: ((city = 'SQL City'::text) AND (type = 'murder'::text))
 Planning Time: 0.585 ms
 Execution Time: 0.104 ms
(4 rows)

Time: 1.460 ms

## Q2 — People with their driver’s license details
                                                               QUERY PLAN                                                                
-----------------------------------------------------------------------------------------------------------------------------------------
 Sort  (cost=1215.46..1240.48 rows=10007 width=60) (actual time=18.144..18.550 rows=10006 loops=1)
   Sort Key: p.name
   Sort Method: quicksort  Memory: 1456kB
   ->  Hash Join  (cost=328.16..550.56 rows=10007 width=60) (actual time=3.200..5.906 rows=10006 loops=1)
         Hash Cond: (p.license_id = dl.id)
         ->  Seq Scan on person p  (cost=0.00..196.11 rows=10011 width=36) (actual time=0.003..0.625 rows=10011 loops=1)
         ->  Hash  (cost=203.07..203.07 rows=10007 width=32) (actual time=3.141..3.143 rows=10007 loops=1)
               Buckets: 16384  Batches: 1  Memory Usage: 793kB
               ->  Seq Scan on drivers_license dl  (cost=0.00..203.07 rows=10007 width=32) (actual time=0.004..1.332 rows=10007 loops=1)
 Planning Time: 0.504 ms
 Execution Time: 18.877 ms
(11 rows)

Time: 20.141 ms

## Q3 — Gym members who checked in on January 9, 2018
                                                                 QUERY PLAN                                                                 
--------------------------------------------------------------------------------------------------------------------------------------------
 Sort  (cost=26.81..26.84 rows=10 width=28) (actual time=0.152..0.153 rows=10 loops=1)
   Sort Key: ci.check_in_time
   Sort Method: quicksort  Memory: 25kB
   ->  Hash Join  (cost=10.50..26.65 rows=10 width=28) (actual time=0.102..0.135 rows=10 loops=1)
         Hash Cond: (ci.membership_id = m.id)
         ->  Bitmap Heap Scan on get_fit_now_check_in ci  (cost=4.36..20.48 rows=10 width=14) (actual time=0.027..0.057 rows=10 loops=1)
               Recheck Cond: (check_in_date = 20180109)
               Heap Blocks: exact=8
               ->  Bitmap Index Scan on idx_checkin_date_time  (cost=0.00..4.36 rows=10 width=0) (actual time=0.023..0.023 rows=10 loops=1)
                     Index Cond: (check_in_date = 20180109)
         ->  Hash  (cost=3.84..3.84 rows=184 width=26) (actual time=0.066..0.066 rows=184 loops=1)
               Buckets: 1024  Batches: 1  Memory Usage: 19kB
               ->  Seq Scan on get_fit_now_member m  (cost=0.00..3.84 rows=184 width=26) (actual time=0.006..0.040 rows=184 loops=1)
 Planning Time: 0.850 ms
 Execution Time: 0.177 ms
(15 rows)

Time: 1.446 ms

## Q4 — Gold gym members and their income
                                                               QUERY PLAN                                                                
-----------------------------------------------------------------------------------------------------------------------------------------
 Sort  (cost=262.88..263.00 rows=51 width=24) (actual time=1.560..1.563 rows=49 loops=1)
   Sort Key: i.annual_income DESC
   Sort Method: quicksort  Memory: 28kB
   ->  Nested Loop  (cost=5.43..261.43 rows=51 width=24) (actual time=0.067..1.544 rows=49 loops=1)
         ->  Hash Join  (cost=5.15..239.48 rows=68 width=24) (actual time=0.046..1.268 rows=68 loops=1)
               Hash Cond: (p.id = m.person_id)
               ->  Seq Scan on person p  (cost=0.00..196.11 rows=10011 width=8) (actual time=0.005..0.574 rows=10011 loops=1)
               ->  Hash  (cost=4.30..4.30 rows=68 width=24) (actual time=0.033..0.033 rows=68 loops=1)
                     Buckets: 1024  Batches: 1  Memory Usage: 12kB
                     ->  Seq Scan on get_fit_now_member m  (cost=0.00..4.30 rows=68 width=24) (actual time=0.007..0.023 rows=68 loops=1)
                           Filter: (membership_status = 'gold'::text)
                           Rows Removed by Filter: 116
         ->  Index Scan using idx_income_ssn on income i  (cost=0.28..0.32 rows=1 width=8) (actual time=0.004..0.004 rows=1 loops=68)
               Index Cond: (ssn = p.ssn)
 Planning Time: 0.545 ms
 Execution Time: 1.586 ms
(16 rows)

Time: 2.445 ms

## Q5 — People who attended Facebook events in 2018
                                                                     QUERY PLAN                                                                      
-----------------------------------------------------------------------------------------------------------------------------------------------------
 Sort  (cost=1046.04..1058.51 rows=4989 width=63) (actual time=6.000..6.358 rows=5025 loops=1)
   Sort Key: fe.date DESC
   Sort Method: quicksort  Memory: 723kB
   ->  Hash Join  (cost=432.67..739.60 rows=4989 width=63) (actual time=3.305..4.943 rows=5025 loops=1)
         Hash Cond: (fe.person_id = p.id)
         ->  Bitmap Heap Scan on facebook_event_checkin fe  (cost=111.42..405.26 rows=4989 width=53) (actual time=0.314..1.123 rows=5025 loops=1)
               Recheck Cond: ((date >= 20180101) AND (date <= 20181231))
               Heap Blocks: exact=219
               ->  Bitmap Index Scan on idx_facebook_date_person  (cost=0.00..110.18 rows=4989 width=0) (actual time=0.296..0.297 rows=5025 loops=1)
                     Index Cond: ((date >= 20180101) AND (date <= 20181231))
         ->  Hash  (cost=196.11..196.11 rows=10011 width=18) (actual time=2.981..2.982 rows=10011 loops=1)
               Buckets: 16384  Batches: 1  Memory Usage: 639kB
               ->  Seq Scan on person p  (cost=0.00..196.11 rows=10011 width=18) (actual time=0.003..1.397 rows=10011 loops=1)
 Planning Time: 0.484 ms
 Execution Time: 6.611 ms
(15 rows)

Time: 7.541 ms

## Q6 — Red-haired Tesla drivers
                                                                 QUERY PLAN                                                                  
---------------------------------------------------------------------------------------------------------------------------------------------
 Sort  (cost=28.13..28.14 rows=2 width=40) (actual time=0.152..0.153 rows=4 loops=1)
   Sort Key: p.name
   Sort Method: quicksort  Memory: 25kB
   ->  Nested Loop  (cost=4.59..28.12 rows=2 width=40) (actual time=0.062..0.144 rows=4 loops=1)
         ->  Bitmap Heap Scan on drivers_license dl  (cost=4.31..11.50 rows=2 width=30) (actual time=0.045..0.052 rows=4 loops=1)
               Recheck Cond: ((hair_color = 'red'::text) AND (car_make = 'Tesla'::text))
               Heap Blocks: exact=4
               ->  Bitmap Index Scan on idx_license_hair_car  (cost=0.00..4.30 rows=2 width=0) (actual time=0.041..0.041 rows=4 loops=1)
                     Index Cond: ((hair_color = 'red'::text) AND (car_make = 'Tesla'::text))
         ->  Index Scan using idx_person_license_id on person p  (cost=0.29..8.30 rows=1 width=18) (actual time=0.020..0.021 rows=1 loops=4)
               Index Cond: (license_id = dl.id)
 Planning Time: 0.259 ms
 Execution Time: 0.175 ms
(13 rows)

Time: 0.787 ms

## Q7 — Interview transcripts mentioning the gym or murder
                                                         QUERY PLAN                                                          
-----------------------------------------------------------------------------------------------------------------------------
 Nested Loop  (cost=0.29..134.17 rows=1 width=61) (actual time=0.414..6.523 rows=4 loops=1)
   ->  Seq Scan on interview i  (cost=0.00..125.86 rows=1 width=51) (actual time=0.406..6.500 rows=4 loops=1)
         Filter: ((transcript ~~* '%gym%'::text) OR (transcript ~~* '%murder%'::text))
         Rows Removed by Filter: 4987
   ->  Index Scan using person_pkey on person p  (cost=0.29..8.30 rows=1 width=18) (actual time=0.004..0.004 rows=1 loops=4)
         Index Cond: (id = i.person_id)
 Planning Time: 0.834 ms
 Execution Time: 6.534 ms
(8 rows)

Time: 7.701 ms

## Q8 — Average income by car make
                                                                  QUERY PLAN                                                                   
-----------------------------------------------------------------------------------------------------------------------------------------------
 Sort  (cost=870.19..870.36 rows=65 width=55) (actual time=8.013..8.017 rows=64 loops=1)
   Sort Key: (round(avg(i.annual_income), 0)) DESC
   Sort Method: quicksort  Memory: 29kB
   ->  HashAggregate  (cost=867.26..868.24 rows=65 width=55) (actual time=7.948..7.969 rows=64 loops=1)
         Group Key: dl.car_make
         Batches: 1  Memory Usage: 32kB
         ->  Hash Join  (cost=531.22..773.36 rows=7512 width=11) (actual time=3.810..6.779 rows=7514 loops=1)
               Hash Cond: (p.license_id = dl.id)
               ->  Hash Join  (cost=203.06..425.47 rows=7515 width=8) (actual time=1.544..3.531 rows=7514 loops=1)
                     Hash Cond: (p.ssn = i.ssn)
                     ->  Seq Scan on person p  (cost=0.00..196.11 rows=10011 width=8) (actual time=0.006..0.454 rows=10011 loops=1)
                     ->  Hash  (cost=109.14..109.14 rows=7514 width=8) (actual time=1.529..1.529 rows=7514 loops=1)
                           Buckets: 8192  Batches: 1  Memory Usage: 358kB
                           ->  Seq Scan on income i  (cost=0.00..109.14 rows=7514 width=8) (actual time=0.006..0.654 rows=7514 loops=1)
               ->  Hash  (cost=203.07..203.07 rows=10007 width=11) (actual time=2.187..2.187 rows=10007 loops=1)
                     Buckets: 16384  Batches: 1  Memory Usage: 567kB
                     ->  Seq Scan on drivers_license dl  (cost=0.00..203.07 rows=10007 width=11) (actual time=0.005..1.078 rows=10007 loops=1)
 Planning Time: 0.507 ms
 Execution Time: 8.080 ms
(19 rows)

Time: 9.440 ms

