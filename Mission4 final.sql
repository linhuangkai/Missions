#import data by Wizard
select*from INCIDENT;
select*from POLICY;

#cleaning table
ALTER TABLE INCIDENT
DROP COLUMN _c39;

DELETE FROM INCIDENT WHERE collision_type='UNKNOWN';
SET SQL_SAFE_UPDATES = 0;
DELETE FROM INCIDENT WHERE collision_type='?';
DELETE FROM INCIDENT WHERE collision_type IS NULL;
DELETE FROM INCIDENT WHERE collision_type='';

ALTER TABLE POLICY
DROP COLUMN insured_education_level;

ALTER TABLE POLICY
DROP COLUMN insured_hobbies;

Alter table INCIDENT
add unique (policy_number);

# using Inner Join to connect data from two tables, there is a PK which is Policy number

SELECT collision_type, total_claim_amount, auto_year
from POLICY
INNER JOIN INCIDENT
ON POLICY.policy_number=INCIDENT.policy_number;

SELECT collision_type, total_claim_amount, auto_year
from POLICY
INNER JOIN INCIDENT
ON POLICY.policy_number=INCIDENT.policy_number
WHERE collision_type= 'Side Collision';

#creat new table name CLAIMING with some attributes
CREATE TABLE CLAIMING
SELECT collision_type, total_claim_amount, auto_year, age, policy_annual_premium
from POLICY
INNER JOIN INCIDENT
ON POLICY.policy_number=INCIDENT.policy_number;

select*from CLAIMING;

# Find the MIN, MAX, AVG, SUM, COUNT of total claim amount
Select
	Min(total_claim_amount) minimun_claim,
    Max(total_claim_amount) maximum_claim,
    AVG(total_claim_amount) average_claim,
    SUM(total_claim_amount) total_sum_claim,
    COUNT(total_claim_amount) total_transaction
FROM INCIDENT;

# Nice table to see the total claim amount and total claim based on Collision Type
Select
	collision_type, SUM(total_claim_amount) Total_claim, count(1) Total_collision_type
From INCIDENT
Group by collision_type;

# The total of claim amount and total claim based on car brand
Select
	auto_make, SUM(total_claim_amount) Total_claim, count(1) Total_auto_make
From INCIDENT
Group by auto_make;

#Total the claim amount and claims in each. year
Select
	auto_year, SUM(total_claim_amount) Total_claim, count(1) Total_auto_year
From INCIDENT
Group by auto_year;

Select cast(AVG(total_claim_amount) as int) as auto_year FROM INCIDENT;

# Finding the MIN and MAX claim amoounnt base on min and max year
Select 
	MIN(total_claim_amount) as min_year,
    MAX(total_claim_amount) as max_year
FROM 
	INCIDENT;
  
  
  # The total claim amount and claims based witness
Select
	witnesses, SUM(total_claim_amount) Total_claim, count(1) Total_claimbywitnesses
From INCIDENT
Group by witnesses;

# The total claim amount and claims based on age
Select
	age, SUM(total_claim_amount) Total_claim, count(1) Total_claimbyage
From CLAIMING
Group by age;

Select
	policy_annual_premium, SUM(total_claim_amount) Total_claim, count(1) Total_claimbyannualpremium
From CLAIMING
Group by policy_annual_premium



select avg(age) as x_bar,
       avg(total_claim_amount) as y_bar
from CLAIMING;

# Finding slope number 
select sum((age - x_bar) * (total_claim_amount - y_bar)) / sum((age - x_bar) * (total_claim_amount - x_bar)) as slope
from (
    select age, avg(age) over () as x_bar,
           total_claim_amount, avg(total_claim_amount) over () as y_bar
    from CLAIMING) s;


select cast(avg(total_claim_amount) as int) as avg_claim from CLAIMING;

select age, SUM(total_claim_amount), avg(total_claim_amount),min(total_claim_amount),max(total_claim_amount), Count(1)
FROM CLAIMING
Group by age;

select age, SUM(total_claim_amount), avg(total_claim_amount),min(total_claim_amount),max(total_claim_amount), Count(1)
FROM CLAIMING
Group by age having sum(total_claim_amount)>avg(total_claim_amount);




