-- where to start with a lost crime scene report.

    SELECT * FROM crime_scene_report 
    WHERE date = 20180115 
    AND type = "murder" 
    AND city = "SQL City" 

-- Two witnesses identified.
-- W1: lives in the last house on the street "Northwestern Dr"

    SELECT *
    FROM person
    WHERE address_street_name = "Northwestern Dr"
    ORDER BY address_number DESC LIMIT 1;

--Morty Schapiro is the first witness! Using his ID number, 14887, we pull a transcript of his interview.

    SELECT * 
    FROM interview
    WHERE person_id = 14887

-- W2: name begins with Annabel and lives on the street "Franklin Ave"

    SELECT * 
    FROM person
    WHERE name LIKE "Annabel _%" AND address_street_name = "Franklin Ave"

-- Annabel Miller and her ID number is 16371 seems to be our second witness. Let’s find out what she said in her interview! 

    SELECT * 
    FROM interview
    WHERE person_id = 16371

-- Alternatively we can use the query below to take care of the queries to find out what the witnesses said on their interviews.

    SELECT person.name, interview.transcript
    FROM person JOIN interview
    ON person.id = interview.person_id
    WHERE person.id = 14887 OR person.id = 16371;

/* Findings from Annabel's interview show that the murder happened on the 9th of January
   From Morty's interview we gathered that the membership number on the bag of the suspect started with "48Z", and the got into a car with a plate that included "H42W"
   Morty mentioned a man, so we know our suspect is male and we have partial carplate characters. */

    SELECT *
    FROM get_fit_now_check_in 
    WHERE membership_id like "%48Z%" AND check_in_date = 20180109 
    order by check_in_date;
    
--We have now narrowed down our search to two people, Let us get some IDs.

    SELECT DISTINCT(get_fit_now_member.id), get_fit_now_member.person_id, get_fit_now_member.membership_status
    FROM get_fit_now_member, get_fit_now_check_in
    WHERE get_fit_now_member.id LIKE "48Z%" 
        AND get_fit_now_member.membership_status = "gold"
        AND get_fit_now_check_in.check_in_date = "20180109";

 --Our findings are leading us to Jeremy Bowers, well...oh well. What did he say on the interview?
     SELECT person.name,
         interview.person_id,
         interview.transcript
    FROM person JOIN interview ON person.id = interview.person_id
    WHERE person.name = "Jeremy Bowers"

/* Mpphh plot twist!🤔
   Our guy is just a hit man hired by a wealthy red haired lady whose height is between  5'5" and  5'7" and who drives a Tesla Model S.
   Our mystery lady is a symphony lover who  attended the SQL Symphony Concert 3 times in December 2017. Let's dig! */
   
     select * 
      from drivers_license 
      join person on drivers_license.id = person.license_id
      where car_make = 'Tesla' and car_model = 'Model S' and gender = 'female' and hair_color = 'red'

  /* We have 3 possible suspects with ID numbers are 202298, 291182, and 918773. Using ID to find their attendance at the SQL Symphony Concert in December 2017.
     We need to narrow down our search, we know her income range and her frequency to the concert.*/
     
     SELECT person.name,
         income.annual_income,
         event.date
    FROM person JOIN facebook_event_checkin AS event
       ON person.id = event.person_id
       JOIN income ON person.ssn = income.ssn
    WHERE event.event_name = "SQL Symphony Concert" 
        AND event.date LIKE "201712%"
        AND person.license_id = 202298 
        OR person.license_id = 291182
        OR person.license_id = 918773

  /* and Voila! We found our villain, Miranda Priestly with an annual income of 310000, which is incredibly high, and she also attended the concert three times in December 2017.
  What was her motive though? Let us confirm with the other sleuths of our findings.*/
  
      INSERT INTO solution VALUES (1, 'Miranda Priestly');
            SELECT value FROM solution;
  
