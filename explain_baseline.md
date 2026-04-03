Pager usage is off.
Timing is on.
# Baseline Execution Plans

## Q1 — All murders in SQL City
                                                     QUERY PLAN                                                     
--------------------------------------------------------------------------------------------------------------------
 Sort  (cost=34.43..34.44 rows=1 width=53) (actual time=0.189..0.190 rows=3 loops=1)
   Sort Key: date DESC
   Sort Method: quicksort  Memory: 25kB
   ->  Seq Scan on crime_scene_report  (cost=0.00..34.42 rows=1 width=53) (actual time=0.018..0.162 rows=3 loops=1)
         Filter: ((city = 'SQL City'::text) AND (type = 'murder'::text))
         Rows Removed by Filter: 1225
 Planning Time: 0.481 ms
 Execution Time: 0.221 ms
(8 rows)

Time: 1.629 ms

## Q2 — People with their driver’s license details
                                                               QUERY PLAN                                                                
-----------------------------------------------------------------------------------------------------------------------------------------
 Sort  (cost=1215.46..1240.48 rows=10007 width=60) (actual time=34.725..36.192 rows=10006 loops=1)
   Sort Key: p.name
   Sort Method: quicksort  Memory: 1456kB
   ->  Hash Join  (cost=328.16..550.56 rows=10007 width=60) (actual time=5.182..9.946 rows=10006 loops=1)
         Hash Cond: (p.license_id = dl.id)
         ->  Seq Scan on person p  (cost=0.00..196.11 rows=10011 width=36) (actual time=0.006..0.771 rows=10011 loops=1)
         ->  Hash  (cost=203.07..203.07 rows=10007 width=32) (actual time=5.020..5.022 rows=10007 loops=1)
               Buckets: 16384  Batches: 1  Memory Usage: 793kB
               ->  Seq Scan on drivers_license dl  (cost=0.00..203.07 rows=10007 width=32) (actual time=0.007..1.897 rows=10007 loops=1)
 Planning Time: 0.723 ms
 Execution Time: 36.768 ms
(11 rows)

Time: 38.204 ms

## Q3 — Gym members who checked in on January 9, 2018
                                                             QUERY PLAN                                                              
-------------------------------------------------------------------------------------------------------------------------------------
 Sort  (cost=58.12..58.14 rows=10 width=28) (actual time=0.319..0.321 rows=10 loops=1)
   Sort Key: ci.check_in_time
   Sort Method: quicksort  Memory: 25kB
   ->  Hash Join  (cost=6.14..57.95 rows=10 width=28) (actual time=0.112..0.311 rows=10 loops=1)
         Hash Cond: (ci.membership_id = m.id)
         ->  Seq Scan on get_fit_now_check_in ci  (cost=0.00..51.79 rows=10 width=14) (actual time=0.016..0.210 rows=10 loops=1)
               Filter: (check_in_date = 20180109)
               Rows Removed by Filter: 2693
         ->  Hash  (cost=3.84..3.84 rows=184 width=26) (actual time=0.089..0.089 rows=184 loops=1)
               Buckets: 1024  Batches: 1  Memory Usage: 19kB
               ->  Seq Scan on get_fit_now_member m  (cost=0.00..3.84 rows=184 width=26) (actual time=0.004..0.028 rows=184 loops=1)
 Planning Time: 0.437 ms
 Execution Time: 0.345 ms
(13 rows)

Time: 1.210 ms

## Q4 — Gold gym members and their income
                                                               QUERY PLAN                                                                
-----------------------------------------------------------------------------------------------------------------------------------------
 Sort  (cost=262.88..263.00 rows=51 width=24) (actual time=2.062..2.072 rows=49 loops=1)
   Sort Key: i.annual_income DESC
   Sort Method: quicksort  Memory: 28kB
   ->  Nested Loop  (cost=5.43..261.43 rows=51 width=24) (actual time=0.069..2.030 rows=49 loops=1)
         ->  Hash Join  (cost=5.15..239.48 rows=68 width=24) (actual time=0.061..1.770 rows=68 loops=1)
               Hash Cond: (p.id = m.person_id)
               ->  Seq Scan on person p  (cost=0.00..196.11 rows=10011 width=8) (actual time=0.006..0.757 rows=10011 loops=1)
               ->  Hash  (cost=4.30..4.30 rows=68 width=24) (actual time=0.043..0.044 rows=68 loops=1)
                     Buckets: 1024  Batches: 1  Memory Usage: 12kB
                     ->  Seq Scan on get_fit_now_member m  (cost=0.00..4.30 rows=68 width=24) (actual time=0.007..0.030 rows=68 loops=1)
                           Filter: (membership_status = 'gold'::text)
                           Rows Removed by Filter: 116
         ->  Index Scan using income_pkey on income i  (cost=0.28..0.32 rows=1 width=8) (actual time=0.003..0.003 rows=1 loops=68)
               Index Cond: (ssn = p.ssn)
 Planning Time: 0.384 ms
 Execution Time: 2.106 ms
(16 rows)

Time: 2.996 ms

## Q5 — People who attended Facebook events in 2018
                                                               QUERY PLAN                                                               
----------------------------------------------------------------------------------------------------------------------------------------
 Sort  (cost=1159.80..1172.27 rows=4987 width=63) (actual time=7.407..7.931 rows=5025 loops=1)
   Sort Key: fe.date DESC
   Sort Method: quicksort  Memory: 723kB
   ->  Hash Join  (cost=321.25..853.50 rows=4987 width=63) (actual time=2.775..6.015 rows=5025 loops=1)
         Hash Cond: (fe.person_id = p.id)
         ->  Seq Scan on facebook_event_checkin fe  (cost=0.00..519.16 rows=4987 width=53) (actual time=0.014..2.170 rows=5025 loops=1)
               Filter: ((date >= 20180101) AND (date <= 20181231))
               Rows Removed by Filter: 14986
         ->  Hash  (cost=196.11..196.11 rows=10011 width=18) (actual time=2.748..2.749 rows=10011 loops=1)
               Buckets: 16384  Batches: 1  Memory Usage: 639kB
               ->  Seq Scan on person p  (cost=0.00..196.11 rows=10011 width=18) (actual time=0.004..1.068 rows=10011 loops=1)
 Planning Time: 0.305 ms
 Execution Time: 8.215 ms
(13 rows)

Time: 9.228 ms

## Q6 — Red-haired Tesla drivers
                                                           QUERY PLAN                                                            
---------------------------------------------------------------------------------------------------------------------------------
 Sort  (cost=475.54..475.54 rows=2 width=40) (actual time=2.771..2.774 rows=4 loops=1)
   Sort Key: p.name
   Sort Method: quicksort  Memory: 25kB
   ->  Hash Join  (cost=253.13..475.53 rows=2 width=40) (actual time=1.907..2.744 rows=4 loops=1)
         Hash Cond: (p.license_id = dl.id)
         ->  Seq Scan on person p  (cost=0.00..196.11 rows=10011 width=18) (actual time=0.007..0.645 rows=10011 loops=1)
         ->  Hash  (cost=253.10..253.10 rows=2 width=30) (actual time=1.117..1.118 rows=4 loops=1)
               Buckets: 1024  Batches: 1  Memory Usage: 9kB
               ->  Seq Scan on drivers_license dl  (cost=0.00..253.10 rows=2 width=30) (actual time=0.134..1.111 rows=4 loops=1)
                     Filter: ((hair_color = 'red'::text) AND (car_make = 'Tesla'::text))
                     Rows Removed by Filter: 10003
 Planning Time: 0.736 ms
 Execution Time: 2.802 ms
(13 rows)

Time: 4.387 ms

## Q7 — Interview transcripts mentioning the gym or murder
                                                         QUERY PLAN                                                          
-----------------------------------------------------------------------------------------------------------------------------
 Nested Loop  (cost=0.29..134.17 rows=1 width=61) (actual time=0.582..9.651 rows=4 loops=1)
   ->  Seq Scan on interview i  (cost=0.00..125.86 rows=1 width=51) (actual time=0.565..9.595 rows=4 loops=1)
         Filter: ((transcript ~~* '%gym%'::text) OR (transcript ~~* '%murder%'::text))
         Rows Removed by Filter: 4987
   ->  Index Scan using person_pkey on person p  (cost=0.29..8.30 rows=1 width=18) (actual time=0.009..0.009 rows=1 loops=4)
         Index Cond: (id = i.person_id)
 Planning Time: 0.818 ms
 Execution Time: 9.675 ms
(8 rows)

Time: 11.116 ms

## Q8 — Average income by car make
                                                                  QUERY PLAN                                                                   
-----------------------------------------------------------------------------------------------------------------------------------------------
 Sort  (cost=870.19..870.36 rows=65 width=55) (actual time=17.841..17.847 rows=64 loops=1)
   Sort Key: (round(avg(i.annual_income), 0)) DESC
   Sort Method: quicksort  Memory: 29kB
   ->  HashAggregate  (cost=867.26..868.24 rows=65 width=55) (actual time=17.742..17.796 rows=64 loops=1)
         Group Key: dl.car_make
         Batches: 1  Memory Usage: 32kB
         ->  Hash Join  (cost=531.22..773.36 rows=7512 width=11) (actual time=5.029..14.902 rows=7514 loops=1)
               Hash Cond: (p.license_id = dl.id)
               ->  Hash Join  (cost=203.06..425.47 rows=7515 width=8) (actual time=1.381..7.303 rows=7514 loops=1)
                     Hash Cond: (p.ssn = i.ssn)
                     ->  Seq Scan on person p  (cost=0.00..196.11 rows=10011 width=8) (actual time=0.004..0.960 rows=10011 loops=1)
                     ->  Hash  (cost=109.14..109.14 rows=7514 width=8) (actual time=1.370..1.371 rows=7514 loops=1)
                           Buckets: 8192  Batches: 1  Memory Usage: 358kB
                           ->  Seq Scan on income i  (cost=0.00..109.14 rows=7514 width=8) (actual time=0.003..0.552 rows=7514 loops=1)
               ->  Hash  (cost=203.07..203.07 rows=10007 width=11) (actual time=3.583..3.583 rows=10007 loops=1)
                     Buckets: 16384  Batches: 1  Memory Usage: 567kB
                     ->  Seq Scan on drivers_license dl  (cost=0.00..203.07 rows=10007 width=11) (actual time=0.006..1.455 rows=10007 loops=1)
 Planning Time: 0.290 ms
 Execution Time: 17.900 ms
(19 rows)

Time: 19.781 ms

