create database hotel_db;
use hotel_db;
show tables;
rename table `hotel bookings` to hotel_bookings;

-- 1. total number of reserverations
select count(*) as total_reserverations 
from hotel_bookings;

-- 2. what is the most popular plan
select type_of_meal_plan, count(*) as total
from hotel_bookings
group by type_of_meal_plan
order by total desc
limit 1;

-- 3. What is the avg price per room(with children)
select avg(avg_price_per_room) as avg_price_with_kids
from hotel_bookings
where no_of_children > 0;

-- 4.  reservations of specific year 
select count(*)
from hotel_bookings
where year(arrival_date) = 2018;

-- 5.  most commonly booked room type
select room_type_reserved, count(*) as count
from hotel_bookings
group by room_type_reserved
order by count desc
limit 1;

-- 6. reservations that fall on weekends
select count(*) as weekend_reservations 
from hotel_bookings
where no_of_weekend_nights > 0;

-- 7. highest and lowest lead time
select max(lead_time) as highest_lead_time,
min(lead_time) as lowest_lead_time from hotel_bookings;

-- 8. most common market segment type
select market_segment_type, count(*) as count
from hotel_bookings
group by market_segment_type
order by count desc
limit 1;

-- 9.  how many reservations are confirmed
select booking_status, count(*) as count
from hotel_bookings
where booking_status = 'confirmed';

-- 10. total number of children and adults
select sum(no_of_adults) as total_Adults,
sum(no_of_children) as total_childern
from hotel_bookings;

-- 11. rank room types by avg prices within each market segment
select market_segment_type, 
room_type_reserved,
avg(avg_price_per_room) as avg_price
from hotel_bookings
group by market_segment_type, room_type_reserved
order by market_segment_type, avg_price desc;

-- 12. top 2 most frequently booked room types per market segment
WITH booking_counts AS (
    SELECT 
        market_segment_type,
        room_type_reserved,
        COUNT(*) AS total,
        RANK() OVER (
            PARTITION BY market_segment_type
            ORDER BY COUNT(*) DESC
        ) AS rank_num
    FROM hotel_bookings
    GROUP BY market_segment_type, room_type_reserved
)
SELECT *
FROM booking_counts
WHERE rank_num <= 2;

-- 13. average number of nights per room type
select room_type_reserved,
avg(no_of_week_nights + no_of_weekend_nights) as total_avg_nights
from hotel_bookings
group by room_type_reserved;

-- 14. most common room types for booking with children and its average price
select room_type_reserved,
avg(avg_price_per_room) as avg_price
from hotel_bookings
where no_of_children > 0
group by room_type_reserved
order by count(*) desc
limit 1;

-- 15. Market segment with highest paying average price 
SELECT market_segment_type, AVG(avg_price_per_room) AS avg_price
FROM hotel_bookings
GROUP BY market_segment_type
ORDER BY avg_price DESC
LIMIT 1;

