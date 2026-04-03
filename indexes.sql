CREATE INDEX IF NOT EXISTS idx_crime_city_type_date
ON crime_scene_report(city, type, date DESC);

CREATE INDEX IF NOT EXISTS idx_person_license_id
ON person(license_id);

CREATE INDEX IF NOT EXISTS idx_person_ssn
ON person(ssn);

CREATE INDEX IF NOT EXISTS idx_checkin_date_time
ON get_fit_now_check_in(check_in_date, check_in_time);

CREATE INDEX IF NOT EXISTS idx_checkin_membership
ON get_fit_now_check_in(membership_id);

CREATE INDEX IF NOT EXISTS idx_member_status
ON get_fit_now_member(membership_status);

CREATE INDEX IF NOT EXISTS idx_member_person_id
ON get_fit_now_member(person_id);

CREATE INDEX IF NOT EXISTS idx_income_ssn
ON income(ssn);

CREATE INDEX IF NOT EXISTS idx_facebook_date_person
ON facebook_event_checkin(date, person_id);

CREATE INDEX IF NOT EXISTS idx_license_hair_car
ON drivers_license(hair_color, car_make);

CREATE INDEX IF NOT EXISTS idx_interview_person_id
ON interview(person_id);
