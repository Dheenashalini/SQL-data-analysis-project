CREATE TABLE AppleStore_description_combined AS

SELECT * FROM appleStore_description1
UNION ALL
SELECT * FROM appleStore_description2
UNION ALL 
SELECT * FROM appleStore_description3
UNION ALL
SELECT * FROM appleStore_description4;

#**EXPLORATORY DATA ANALYSIS** 

#--check the number of unique apps in both tablesAppleStore--

SELECT COUNT(DISTINCT id) as unique_app_ids 
from AppleStore;

SELECT count(DISTINCT id) AS unique_app_des_ids
from AppleStore_description_combined;

#--check for missing values in key fields--

SELECT COUNT(*) AS missing_values
from AppleStore
where id is null or track_name is NULL or user_rating is NULL or prime_genre is null;

SELECT COUNT(*) AS desp_missing_values
from AppleStore_description_combined
where id is null or track_name is null or app_desc is null;

#--find the number of apps per genre--

SELECT prime_genre, count(*) as num_of_apps
from AppleStore
GROUP by prime_genre
ORDER by num_of_apps DESC;

#--Get an overview of apps ratings-- 

SELECT min(user_rating) as lowest_rating,
       max(user_rating) as highest_rating,
       avg(user_rating) as avg_rating
from AppleStore;

#--Get the distribution of app prices

SELECT (price /2) *2 as PriceBinStart,
       ((price / 2) *2) + 2 as PriceBinEnd,
       COUNT(*) as NumApps
from Applestore
group by PriceBinStart
order by PriceBinStart;

#**DATA ANALYSIS** 

#--Determine whether the paid apps have a higher rating than free apps-- 

SELECT case when price >0 then "paid" ELSE "free" end as app_type,
       AVG(user_rating) as user_rating
from AppleStore
GROUP by app_type;

#--Check if apps with more language supp has higher ratings-- 

SELECT case when lang_num <10 then '<10 languages'
            when lang_num BETWEEN 10 and 30 then '10-30 languages'
            else 'more than 30 languages'
       END as languages,
       avg(user_rating) as avg_user_ratings
from AppleStore
GROUP by languages
order by avg_user_ratings DESC;

#--check genres with low ratings--

SELECT prime_genre, avg(user_rating) as ratings
from AppleStore
GROUP by prime_genre
order by ratings asc
limit 5;

#--check if there is a correlation  between the length of the app_description and its user_ratings 

SELECT case when length(d.app_desc)< 500 then "short" 
            when length(d.app_desc) BETWEEN 500 and 1000 then "medium" 
            else "long" end
as description_length, 
       avg(a.user_rating) as rating 
from AppleStore_description_combined d 
join AppleStore a on d.id = a.id
GROUP by description_length
ORDER by rating DESC;

#--check the top rated apps for each genre-- 

SELECT prime_genre , track_name, user_rating
from (
      SELECT prime_genre, track_name, user_rating, 
		Rank() OVER(Partition by prime_genre order by user_rating DESC, rating_count_tot DESC)
       as ranking from AppleStore 
	 ) as a
where a.rank = 1; 
      
     


            

               
            
                         
                    