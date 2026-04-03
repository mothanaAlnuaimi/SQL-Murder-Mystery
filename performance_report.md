# Performance Report

## Queries that improved the most
- Q6 showed the biggest improvement, dropping from **2.802 ms** to **0.175 ms**. This is a reduction of about **93.8%**. The composite index on `(hair_color, car_make)` matched the filtering conditions directly and made the query much faster.
- Q8 improved from **17.900 ms** to **8.080 ms**, a reduction of about **54.9%**. This improvement came from adding indexes on important join columns such as `person(license_id)`, `person(ssn)`, and `income(ssn)`.
- Q1 improved from **0.221 ms** to **0.104 ms**, a reduction of about **52.9%**. The composite index on `(city, type, date DESC)` reduced filtering work and helped with ordering.
- Q2 improved from **36.768 ms** to **18.877 ms**, a reduction of about **48.7%**. Indexing the join columns reduced the join cost significantly.
- Q3 improved from **0.345 ms** to **0.177 ms**, also a reduction of about **48.7%**. The index on `(check_in_date, check_in_time)` helped PostgreSQL filter the target date and support sorting efficiently.

## Queries with moderate or limited improvement
- Q7 improved from **9.675 ms** to **6.534 ms**, a reduction of about **32.5%**. This is an improvement, but it is still limited compared with the best-performing queries. The reason is that `ILIKE '%gym%'` and `ILIKE '%murder%'` use leading wildcards, which do not benefit directly from a standard B-tree index. The improvement likely came from reduced join overhead rather than faster text filtering.
- Q4 improved from **2.106 ms** to **1.586 ms**, a reduction of about **24.7%**. This is a useful but smaller improvement.
- Q5 improved from **8.215 ms** to **6.611 ms**, a reduction of about **19.5%**. The query benefited from indexing, but the gain was more modest than in other cases.

## Tradeoffs
- Indexes improved read performance for most of the tested queries.
- Indexes required additional storage space.
- Write operations such as `INSERT`, `UPDATE`, and `DELETE` would become slightly slower because PostgreSQL must also maintain the indexes.

## Production recommendation
Based on the measured results, I would keep the indexes that support filtering and joins effectively:

- `crime_scene_report(city, type, date DESC)`
- `person(license_id)`
- `person(ssn)`
- `get_fit_now_check_in(check_in_date, check_in_time)`
- `get_fit_now_check_in(membership_id)`
- `get_fit_now_member(membership_status)`
- `get_fit_now_member(person_id)`
- `income(ssn)`
- `facebook_event_checkin(date, person_id)`
- `drivers_license(hair_color, car_make)`

I would not rely on a normal B-tree index for transcript wildcard searches like Q7. If text-search queries become common in production, I would consider a more specialized solution such as full-text search or trigram indexing.