-- exploring the data set:
select max(total_laid_off), max(percentage_laid_off)
from layoffs_staging_2;

select *
from layoffs_staging_2 
where percentage_laid_off =1
order by total_laid_off desc;


select *
from layoffs_staging_2 
where percentage_laid_off =1
order by funds_raised_millions desc;
	
    
select company, sum(total_laid_off)
from layoffs_staging_2
group by company
order by 2 desc;

select min(`date`), max(`date`)
from layoffs_staging_2;

   
select industry, sum(total_laid_off), `date`
from layoffs_staging_2
group by industry, `date`
order by 3 desc;

select country, sum(total_laid_off)
from layoffs_staging_2
group by country
order by 2 desc;


select year(`date`), sum(total_laid_off)
from layoffs_staging_2
group by year(`date`)
order by 1 desc;


select stage, sum(total_laid_off)
from layoffs_staging_2
group by stage
order by 2 desc;

-- rolling total layoffs: 
select substring(`date`,1,7) as `Month`,  sum(total_laid_off)
from layoffs_staging_2
where substring(`date`,1,7) is not null
group by `Month`
order by 1 asc;

-- now rolling sum for this:
with rolling_total as
(
select substring(`date`,1,7) as `Month`,  sum(total_laid_off) as total_off
from layoffs_staging_2
where substring(`date`,1,7) is not null
group by `Month`
order by 1 asc
)
select `Month`, total_off, sum(total_off) over(order by `Month`) as rolling_total
from rolling_total;

select company, sum(total_laid_off)
from layoffs_staging_2
group by company
order by 2 desc;

select company, year(`date`), sum(total_laid_off)
from layoffs_staging_2
group by company, year(`date`)
order by company asc;

select company, year(`date`), sum(total_laid_off)
from layoffs_staging_2
group by company, year(`date`)
order by 3 desc;

with company_year (company, years, total_laid_off) as 
(
select company, year(`date`), sum(total_laid_off)
from layoffs_staging_2
group by company, year(`date`)
)
select *
from company_year;




WITH Company_Year AS 
(
  SELECT company, YEAR(date) AS years, SUM(total_laid_off) AS total_laid_off
  FROM layoffs_staging_2
  GROUP BY company, YEAR(date)
)
, Company_Year_Rank AS (
  SELECT company, years, total_laid_off, DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off DESC) AS ranking
  FROM Company_Year
)
SELECT company, years, total_laid_off, ranking
FROM Company_Year_Rank
WHERE ranking <= 3
AND years IS NOT NULL
ORDER BY years ASC, total_laid_off DESC;
