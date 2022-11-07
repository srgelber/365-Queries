-- Lab 6
-- sgelber
-- May 24, 2022

USE `BAKERY`;
-- BAKERY-1
-- Find all customers who did not make a purchase between October 5 and October 11 (inclusive) of 2007. Output first and last name in alphabetical order by last name.
SELECT DISTINCT FirstName, LastName FROM goods
JOIN items ON items.Item = goods.GId
JOIN receipts ON receipts.RNumber = items.Receipt
JOIN customers On receipts.Customer = customers.CId
WHERE CId NOT IN (
SELECT DISTINCT CId FROM goods
JOIN items ON items.Item = goods.GId
JOIN receipts ON receipts.RNumber = items.Receipt
JOIN customers On receipts.Customer = customers.CId
WHERE SaleDate between "2007-10-05" and "2007-10-11")
ORDER BY LastName;


USE `BAKERY`;
-- BAKERY-2
-- Find the customer(s) who spent the most money at the bakery during October of 2007. Report first, last name and total amount spent (rounded to two decimal places). Sort by last name.
SELECT G1.FirstName, G1.LastName, ROUND(G1.MoneySpent,2) as MoneySpent FROM (SELECT FirstName, LastName, sum(Price) as MoneySpent FROM goods
JOIN items ON items.Item = goods.GId
JOIN receipts ON receipts.RNumber = items.Receipt
JOIN customers On receipts.Customer = customers.CId
WHERE Month(SaleDate) = 10 and Year(SaleDate) = 2007
GROUP BY CId) AS G1
WHERE G1.MoneySpent = (
SELECT MAX(T1.MoneySpent) as MaxMoneySpent FROM
(SELECT CId, sum(Price) as MoneySpent FROM goods
JOIN items ON items.Item = goods.GId
JOIN receipts ON receipts.RNumber = items.Receipt
JOIN customers On receipts.Customer = customers.CId
WHERE Month(SaleDate) = 10 and Year(SaleDate) = 2007
GROUP BY CId) as T1)
ORDER BY G1.LastName;


USE `BAKERY`;
-- BAKERY-3
-- Find all customers who never purchased a twist ('Twist') during October 2007. Report first and last name in alphabetical order by last name.

SELECT DISTINCT FirstName, LastName FROM goods
JOIN items ON items.Item = goods.GId
JOIN receipts ON receipts.RNumber = items.Receipt
JOIN customers On receipts.Customer = customers.CId
WHERE CId NOT IN (
SELECT DISTINCT CId FROM goods
JOIN items ON items.Item = goods.GId
JOIN receipts ON receipts.RNumber = items.Receipt
JOIN customers On receipts.Customer = customers.CId
WHERE Month(SaleDate) = 10 and Year(SaleDate) = 2007 and Food = "Twist")
ORDER BY LastName;


USE `BAKERY`;
-- BAKERY-4
-- Find the baked good(s) (flavor and food type) responsible for the most total revenue.
WITH Typerev as (SELECT Flavor, Food, sum(Price) as rev FROM goods
JOIN items ON items.Item = goods.GId
JOIN receipts ON receipts.RNumber = items.Receipt
GROUP BY Flavor, Food)

SELECT Flavor, Food from Typerev
WHERE rev = (select max(rev) from Typerev);


USE `BAKERY`;
-- BAKERY-5
-- Find the most popular item, based on number of pastries sold. Report the item (flavor and food) and total quantity sold.
WITH Typerev as (SELECT Flavor, Food, Count(*) as sold FROM goods
JOIN items ON items.Item = goods.GId
JOIN receipts ON receipts.RNumber = items.Receipt
GROUP BY Flavor, Food)

SELECT Flavor, Food, sold as TotalQty from Typerev
WHERE sold = (select max(sold) from Typerev);


USE `BAKERY`;
-- BAKERY-6
-- Find the date(s) of highest revenue during the month of October, 2007. In case of tie, sort chronologically.
WITH Daterev as (SELECT SaleDate, sum(Price) as rev FROM goods
JOIN items ON items.Item = goods.GId
JOIN receipts ON receipts.RNumber = items.Receipt
WHERE Month(SaleDate) = 10 and Year(SaleDate) = 2007
GROUP BY SaleDate
ORDER BY SaleDate)

SELECT SaleDate from Daterev
WHERE rev = (select max(rev) from Daterev)
ORDER BY SaleDate;


USE `BAKERY`;
-- BAKERY-7
-- Find the best-selling item(s) (by number of purchases) on the day(s) of highest revenue in October of 2007.  Report flavor, food, and quantity sold. Sort by flavor and food.
WITH Daterev as (SELECT SaleDate, sum(Price) as rev FROM goods
JOIN items ON items.Item = goods.GId
JOIN receipts ON receipts.RNumber = items.Receipt
WHERE Month(SaleDate) = 10 and Year(SaleDate) = 2007
GROUP BY SaleDate
ORDER BY SaleDate),

Typerev as (SELECT SaleDate, Flavor, Food, Count(*) as sold FROM goods
JOIN items ON items.Item = goods.GId
JOIN receipts ON receipts.RNumber = items.Receipt
GROUP BY SaleDate, Flavor, Food),


Comb as (SELECT SaleDate, Flavor, Food, sold as TotalQty from Typerev
WHERE SaleDate = (SELECT SaleDate from Daterev
WHERE rev = (select max(rev) from Daterev)))

SELECT Flavor, Food, TotalQty FROM Comb
WHERE TotalQty = (SELECT max(TotalQty) from Comb)
ORDER BY Flavor, Food;


USE `BAKERY`;
-- BAKERY-8
-- For every type of Cake report the customer(s) who purchased it the largest number of times during the month of October 2007. Report the name of the pastry (flavor, food type), the name of the customer (first, last), and the quantity purchased. Sort output in descending order on the number of purchases, then in alphabetical order by last name of the customer, then by flavor.
WITH cakes as (SELECT Flavor, Food, FirstName, LastName, Count(*) as qty FROM goods
JOIN items ON items.Item = goods.GId
JOIN receipts ON receipts.RNumber = items.Receipt
JOIN customers On receipts.Customer = customers.CId
WHERE Month(SaleDate) = 10 and Year(SaleDate) = 2007 and Food = "Cake"
GROUP BY Flavor, Food, FirstName, LastName)

SELECT Flavor, Food, FirstName, LastName, qty FROM cakes c1
WHERE qty = (SELECT max(qty) from cakes c2
WHERE c1.Flavor = c2.Flavor and c1.Food = c2.Food)
ORDER BY qty DESC, LastName, Flavor;


USE `BAKERY`;
-- BAKERY-9
-- Output the names of all customers who made multiple purchases (more than one receipt) on the latest day in October on which they made a purchase. Report names (last, first) of the customers and the *earliest* day in October on which they made a purchase, sorted in chronological order, then by last name.

WITH LatestSale as (SELECT Max(SaleDate) as LastSale, CId as c1, FirstName, LastName FROM goods
JOIN items ON items.Item = goods.GId
JOIN receipts ON receipts.RNumber = items.Receipt
JOIN customers On receipts.Customer = customers.CId
WHERE Month(SaleDate) = 10 and Year(SaleDate) = 2007
GROUP BY CId),

EarliestSale as (SELECT Min(SaleDate) as EarliestSale, CId as c2, FirstName, LastName FROM goods
JOIN items ON items.Item = goods.GId
JOIN receipts ON receipts.RNumber = items.Receipt
JOIN customers On receipts.Customer = customers.CId
WHERE Month(SaleDate) = 10 and Year(SaleDate) = 2007
GROUP BY CId)

SELECT LS.LastName, LS.FirstName, EarliestSale From receipts
JOIN LatestSale as LS ON c1 = customer and LastSale = SaleDate
JOIN EarliestSale as ES ON c2 = customer
GROUP BY customer
HAVING count(*) > 1
ORDER BY EarliestSale, LastName;


USE `BAKERY`;
-- BAKERY-10
-- Find out if sales (in terms of revenue) of Chocolate-flavored items or sales of Croissants (of all flavors) were higher in October of 2007. Output the word 'Chocolate' if sales of Chocolate-flavored items had higher revenue, or the word 'Croissant' if sales of Croissants brought in more revenue.

WITH CroiSales as (SELECT Food, sum(Price) as Croirev FROM goods
JOIN items ON items.Item = goods.GId
JOIN receipts ON receipts.RNumber = items.Receipt
WHERE Food = "Croissant" and Month(SaleDate) = 10 and Year(SaleDate) = 2007
GROUP BY Food),
ChocSales as (SELECT Flavor, sum(Price) as Chocrev FROM goods
JOIN items ON items.Item = goods.GId
JOIN receipts ON receipts.RNumber = items.Receipt
WHERE Flavor = "Chocolate" and Month(SaleDate) = 10 and Year(SaleDate) = 2007
GROUP BY Flavor)


SELECT 
CASE WHEN Chocrev > Croirev THEN "Chocolate"
    ELSE "Croissant"
END as HigherRev FROM CroiSales JOIN ChocSales;


USE `INN`;
-- INN-1
-- Find the most popular room(s) (based on the number of reservations) in the hotel  (Note: if there is a tie for the most popular room, report all such rooms). Report the full name of the room, the room code and the number of reservations.

WITH resnum as (SELECT RoomName, RoomCode, Count(*) as NumberofReservations FROM reservations
JOIN rooms ON rooms.RoomCode = reservations.Room
GROUP BY RoomName, RoomCode)

SELECT RoomName, RoomCode, NumberofReservations from resnum
WHERE NumberofReservations = (select max(NumberofReservations) from resnum);


USE `INN`;
-- INN-2
-- Find the room(s) that have been occupied the largest number of days based on all reservations in the database. Report the room name(s), room code(s) and the number of days occupied. Sort by room name.
WITH resnum as (SELECT RoomName, Room, DateDiff(CheckOut,CheckIn) as NumofRes FROM reservations
JOIN rooms ON rooms.RoomCode = reservations.Room
GROUP BY Room, CheckOut, CheckIn),
total as (SELECT Room, RoomName, sum(NumofRes) as Total FROM resnum GROUP BY Room)

select RoomName, Room, Total from total
WHERE Total = (SELECT max(Total) FROM total)
ORDER BY RoomName;


USE `INN`;
-- INN-3
-- For each room, report the most expensive reservation. Report the full room name, dates of stay, last name of the person who made the reservation, daily rate and the total amount paid (rounded to the nearest penny.) Sort the output in descending order by total amount paid.
WITH resnum as (SELECT CODE, RoomName, Room, FirstName, LastName, CheckIn, CheckOut, DateDiff(CheckOut,CheckIn) * Rate as ResCost, Rate FROM reservations
JOIN rooms ON rooms.RoomCode = reservations.Room
GROUP BY CODE)

select RoomName, CheckIn, CheckOut, LastName, ROUND(rate,2) as Rate, ROUND(ResCost,2) as Total from resnum r1
WHERE r1.ResCost = (SELECT max(r2.ResCost) FROM resnum r2 WHERE r1.Room = r2.Room)
ORDER BY ResCost DESC;


USE `INN`;
-- INN-4
-- For each room, report whether it is occupied or unoccupied on July 4, 2010. Report the full name of the room, the room code, and either 'Occupied' or 'Empty' depending on whether the room is occupied on that day. (the room is occupied if there is someone staying the night of July 4, 2010. It is NOT occupied if there is a checkout on this day, but no checkin). Output in alphabetical order by room code. 
WITH resnum as (SELECT RoomName, Room,
CASE WHEN (CheckIn <= "2010-07-04" and CheckOut > "2010-07-04")
     THEN "Occupied"
     ELSE "Empty"
END as Jul4Status FROM reservations
JOIN rooms ON rooms.RoomCode = reservations.Room
GROUP BY Room, Jul4Status),
occupied as (SELECT RoomName, Room, Jul4Status FROM resnum WHERE Jul4Status = "Occupied")

select RoomName, Room, 
CASE WHEN (Room IN (SELECT Room FROM occupied))
     THEN "Occupied"
     ELSE "Empty"
END as Jul4Status from resnum
GROUP BY Room
ORDER BY Room;


USE `INN`;
-- INN-5
-- Find the highest-grossing month (or months, in case of a tie). Report the month name, the total number of reservations and the revenue. For the purposes of the query, count the entire revenue of a stay that commenced in one month and ended in another towards the earlier month. (e.g., a September 29 - October 3 stay is counted as September stay for the purpose of revenue computation). In case of a tie, months should be sorted in chronological order.
WITH monthrev as (SELECT distinct MONTH(CheckIn) as Month, sum(DATEDIFF(CheckOut,CheckIn) * Rate) as Rev, Count(*) as NReservations
FROM reservations GROUP BY Month ORDER BY Month),
highest as (select STR_TO_DATE(Month,'%m') as monthNum, MONTHNAME(STR_TO_DATE(Month,'%m')) as Month, NReservations, Rev from monthrev)

select Month, NReservations, Rev from highest
where Rev = (SELECT max(Rev) from highest)
ORDER BY monthNum;


USE `STUDENTS`;
-- STUDENTS-1
-- Find the teacher(s) with the largest number of students. Report the name of the teacher(s) (last, first) and the number of students in their class.

WITH studentcount as (select teachers.Last, teachers.First, count(*) as nstudents from list
JOIN teachers ON teachers.classroom = list.classroom
GROUP BY teachers.classroom, teachers.Last, teachers.First)

SELECT Last, First, nstudents FROM studentcount
WHERE nstudents = (SELECT max(nstudents) FROM studentcount);


USE `STUDENTS`;
-- STUDENTS-2
-- Find the grade(s) with the largest number of students whose last names start with letters 'A', 'B' or 'C' Report the grade and the number of students. In case of tie, sort by grade number.
WITH ABCcount as (select Grade, count(LastName) as ABCCount from list
WHERE LastName like "A%" or LastName like "B%" or LastName like "C%"
GROUP BY Grade)

SELECT Grade, ABCcount FROM ABCcount
WHERE ABCCount = (SELECT max(ABCcount) FROM ABCcount)
ORDER BY Grade;


USE `STUDENTS`;
-- STUDENTS-3
-- Find all classrooms which have fewer students in them than the average number of students in a classroom in the school. Report the classroom numbers and the number of student in each classroom. Sort in ascending order by classroom.
WITH Classcount as (select Classroom, count(LastName) as ns from list
GROUP BY Classroom),
classaverage as (select AVG(ns) as classavg FROM Classcount)

select Classroom, ns from Classcount
JOIN classaverage
WHERE ns < classavg
ORDER BY Classroom ASC;


USE `STUDENTS`;
-- STUDENTS-4
-- Find all pairs of classrooms with the same number of students in them. Report each pair only once. Report both classrooms and the number of students. Sort output in ascending order by the number of students in the classroom.
WITH Classcount as (select Classroom, count(LastName) as ns from list
GROUP BY Classroom)

SELECT c1.Classroom, c2.Classroom, c1.ns as StudentCount FROM Classcount c1
JOIN Classcount c2 ON c2.ns = c1.ns and c1.Classroom != c2.Classroom
WHERE c1.Classroom < c2.Classroom
ORDER BY c1.ns ASC;


USE `STUDENTS`;
-- STUDENTS-5
-- For each grade with more than one classroom, report the grade and the last name of the teacher who teaches the classroom with the largest number of students in the grade. Output results in ascending order by grade.
WITH gradeclassrooms as (
SELECT Grade FROM list 
GROUP BY Grade 
HAVING Count(Distinct Classroom) > 1),

studentsperclass as (select Grade, list.Classroom, Last, count(LastName) as ns from list
JOIN teachers ON teachers.Classroom = list.Classroom
WHERE Grade IN (SELECT * FROM gradeclassrooms)
GROUP BY Grade, Classroom)

select Grade, Last from studentsperclass c1
WHERE ns = (SELECT max(ns) from studentsperclass c2 WHERE c1.Grade = c2.Grade)
ORDER BY Grade ASC;


USE `CSU`;
-- CSU-1
-- Find the campus(es) with the largest enrollment in 2000. Output the name of the campus and the enrollment. Sort by campus name.

WITH campusEnrollment as (select Campus, Sum(Enrolled) as Enrollment from campuses
JOIN enrollments ON enrollments.CampusId = campuses.Id
WHERE enrollments.year = 2000
GROUP BY Id)


select * from campusEnrollment
WHERE Enrollment = (SELECT max(Enrollment) FROM campusEnrollment)
ORDER BY Campus;


USE `CSU`;
-- CSU-2
-- Find the university (or universities) that granted the highest average number of degrees per year over its entire recorded history. Report the name of the university, sorted alphabetically.

WITH campusEnrollment as (select Campus, Id, Sum(degrees) as DegreesPerYear from campuses
JOIN degrees ON degrees.CampusId = campuses.Id
GROUP BY degrees.year, CampusId),
avgPerYear as (select Campus, Id, avg(degreesPerYear) as avg from campusEnrollment group by Id)

select Campus from avgPerYear WHERE avg = (SELECT max(avg) FROM avgPerYear) ORDER BY Campus;


USE `CSU`;
-- CSU-3
-- Find the university with the lowest student-to-faculty ratio in 2003. Report the name of the campus and the student-to-faculty ratio, rounded to one decimal place. Use FTE numbers for enrollment. In case of tie, sort by campus name.
WITH campusEnrollment as (select Campus, ROUND(enrollments.FTE/faculty.fte,1) as studentFacultyRatio from campuses
JOIN enrollments ON enrollments.CampusId = campuses.Id
JOIN faculty ON faculty.CampusId = campuses.Id and faculty.Year = enrollments.Year
WHERE enrollments.year = 2003
GROUP BY Id)

select * from campusEnrollment
WHERE studentFacultyRatio = (SELECT min(studentFacultyRatio) FROM campusEnrollment)
ORDER BY Campus;


USE `CSU`;
-- CSU-4
-- Among undergraduates studying 'Computer and Info. Sciences' in the year 2004, find the university with the highest percentage of these students (base percentages on the total from the enrollments table). Output the name of the campus and the percent of these undergraduate students on campus. In case of tie, sort by campus name.
WITH campusEnrollment as (select Campus, campuses.Id, Sum(Enrolled) as Enrollment from campuses
JOIN enrollments ON enrollments.CampusId = campuses.Id
WHERE enrollments.year = 2004
GROUP BY Id),
csEnrollment as (select Campus, campuses.Id, Sum(Ug) as CSUgEnr from campuses
JOIN discEnr ON discEnr.CampusId = campuses.Id
JOIN disciplines ON disciplines.Id = discEnr.Discipline
WHERE discEnr.year = 2004 and disciplines.Name = "Computer and Info. Sciences"
GROUP BY CampusId, Discipline),
csPercent as (select campusEnrollment.Campus, campusEnrollment.Id, ROUND((CSUgEnr/Enrollment) * 100,1) as Percent FROM campusEnrollment
JOIN csEnrollment ON csEnrollment.Id = campusEnrollment.Id)

select Campus, Percent from csPercent
WHERE Percent = (SELECT max(Percent) FROM csPercent)
ORDER BY Campus;


USE `CSU`;
-- CSU-5
-- For each year between 1997 and 2003 (inclusive) find the university with the highest ratio of total degrees granted to total enrollment (use enrollment numbers). Report the year, the name of the campuses, and the ratio. List in chronological order.
WITH campusEnrollment as (select enrollments.Year, Campus, campuses.Id, Sum(Enrolled) as Enrollment from campuses
JOIN enrollments ON enrollments.CampusId = campuses.Id
WHERE enrollments.year between 1997 and 2003
GROUP BY Id, enrollments.Year),
degreesGiven as (select degrees.Year, Campus, campuses.Id, Sum(degrees) as degreesGiven from campuses
JOIN degrees ON degrees.CampusId = campuses.Id
WHERE degrees.year between 1997 and 2003
GROUP BY CampusId, degrees.Year),
degPercent as (select degreesGiven.Year, campusEnrollment.Campus, campusEnrollment.Id, (degreesGiven/Enrollment) as Percent FROM campusEnrollment
JOIN degreesGiven ON degreesGiven.Id = campusEnrollment.Id and degreesGiven.Year = campusEnrollment.Year)

select Year, Campus, Percent from degPercent d1
WHERE Percent = (SELECT max(Percent) FROM degPercent d2 WHERE d1.Year = d2.Year)
ORDER BY Year;


USE `CSU`;
-- CSU-6
-- For each campus report the year of the highest student-to-faculty ratio, together with the ratio itself. Sort output in alphabetical order by campus name. Use FTE numbers to compute ratios and round to two decimal places.
WITH campusEnrollment as (select enrollments.Year, Campus, ROUND(enrollments.FTE/faculty.fte,2) as studentFacultyRatio from campuses
JOIN enrollments ON enrollments.CampusId = campuses.Id
JOIN faculty ON faculty.CampusId = campuses.Id and faculty.Year = enrollments.Year
GROUP BY Id, enrollments.Year)

select Campus, Year, studentFacultyRatio from campusEnrollment c1
WHERE studentFacultyRatio = (SELECT max(studentFacultyRatio) FROM campusEnrollment c2 WHERE c1.Campus = c2.Campus)
ORDER BY Campus;


USE `CSU`;
-- CSU-7
-- For each year for which the data is available, report the total number of campuses in which student-to-faculty ratio became worse (i.e. more students per faculty) as compared to the previous year. Report in chronological order.

WITH campusEnrollment as (select enrollments.Year, Campus, ROUND(enrollments.FTE/faculty.fte,2) as studentFacultyRatio from campuses
JOIN enrollments ON enrollments.CampusId = campuses.Id
JOIN faculty ON faculty.CampusId = campuses.Id and faculty.Year = enrollments.Year
GROUP BY Id, enrollments.Year)

select Year+1 as Year, count(*) as Campuses from campusEnrollment c1
WHERE studentFacultyRatio < (SELECT max(studentFacultyRatio) FROM campusEnrollment c2 WHERE c1.Campus = c2.Campus
and c2.Year = c1.Year + 1)
GROUP BY Year
ORDER BY Year;


USE `MARATHON`;
-- MARATHON-1
-- Find the state(s) with the largest number of participants. List state code(s) sorted alphabetically.

WITH statecount as (select State, Count(distinct Place) as count from marathon group by State)

SELECT State FROM statecount where count = (select max(count) from statecount)
ORDER BY State;


USE `MARATHON`;
-- MARATHON-2
-- Find all towns in Rhode Island (RI) which fielded more female runners than male runners for the race. Include only those towns that fielded at least 1 male runner and at least 1 female runner. Report the names of towns, sorted alphabetically.

WITH malecount as (select Town, count(distinct Place) as mnum from marathon
WHERE State = "RI" and sex = "M"
group by Town
HAVING count(distinct Place) >= 1),
femalecount as (select Town, count(distinct Place) as fnum from marathon
WHERE State = "RI" and sex = "F"
group by Town
HAVING count(distinct Place) >= 1),
comb as (select malecount.Town, mnum, fnum from malecount join femalecount ON malecount.Town = femalecount.Town)

select Town from comb
WHERE fnum > mnum
ORDER BY Town;


USE `MARATHON`;
-- MARATHON-3
-- For each state, report the gender-age group with the largest number of participants. Output state, age group, gender, and the number of runners in the group. Report only information for the states where the largest number of participants in a gender-age group is greater than one. Sort in ascending order by state code, age group, then gender.
WITH groupcount as (select State, AgeGroup, Sex, count(distinct Place) as numGroup from marathon
group by State, AgeGroup, Sex
HAVING count(distinct Place) > 1)

select State, AgeGroup, Sex, numGroup from groupcount g1
WHERE numGroup = (SELECT max(numGroup) from groupcount g2 
where g1.State = g2.State)
ORDER BY State, AgeGroup, Sex;


USE `MARATHON`;
-- MARATHON-4
-- Find the 30th fastest female runner. Report her overall place in the race, first name, and last name. This must be done using a single SQL query (which may be nested) that DOES NOT use the LIMIT clause. Think carefully about what it means for a row to represent the 30th fastest (female) runner.
SELECT Place, FirstName, Lastname FROM marathon m1
WHERE Sex = "F" and (SELECT count(*) as placesbelow from marathon m2
where m2.Sex = "F" and m2.Place < m1.Place) = 29;


USE `MARATHON`;
-- MARATHON-5
-- For each town in Connecticut report the total number of male and the total number of female runners. Both numbers shall be reported on the same line. If no runners of a given gender from the town participated in the marathon, report 0. Sort by number of total runners from each town (in descending order) then by town.

WITH malecount as (select Town, count(Place) as mnum from marathon
WHERE State = "CT" and sex = "M"
group by Town),
totalcount as (select Town, count(Place) as tnum from marathon
WHERE State = "CT"
group by Town)

select totalcount.Town,
CASE WHEN mnum is NULL THEN 0
     ELSE mnum
END as Men, 
CASE WHEN mnum is NULL THEN tnum
     ELSE tnum - mnum
END as Women from totalcount
left outer join malecount ON malecount.Town = totalcount.Town
ORDER BY tnum DESC, totalcount.Town;


USE `KATZENJAMMER`;
-- KATZENJAMMER-1
-- Report the first name of the performer who never played accordion.

SELECT Distinct FirstName from Instruments
JOIN Band ON Band.Id = Instruments.Bandmate where Bandmate NOT IN (select Distinct Bandmate from Instruments where Instrument = "accordion");


USE `KATZENJAMMER`;
-- KATZENJAMMER-2
-- Report, in alphabetical order, the titles of all instrumental compositions performed by Katzenjammer ("instrumental composition" means no vocals).

SELECT Title FROM Songs WHERE SongId NOT IN (select Distinct Song from Vocals) ORDER BY Title;


USE `KATZENJAMMER`;
-- KATZENJAMMER-3
-- Report the title(s) of the song(s) that involved the largest number of different instruments played (if multiple songs, report the titles in alphabetical order).
WITH instCount as (SELECT Title, Count(distinct Instrument) as InstrumentsPlayed from Songs
JOIN Instruments ON Instruments.Song = Songs.SongId
GROUP BY SongId)

SELECT Title FROM instCount WHERE InstrumentsPlayed = (select max(InstrumentsPlayed) from instCount)
ORDER BY Title;


USE `KATZENJAMMER`;
-- KATZENJAMMER-4
-- Find the favorite instrument of each performer. Report the first name of the performer, the name of the instrument, and the number of songs on which the performer played that instrument. Sort in alphabetical order by the first name, then instrument.

WITH instCount as (SELECT FirstName, Instrument, Count(Instrument) as num from Songs
JOIN Instruments ON Instruments.Song = Songs.SongId
JOIN Band ON Band.Id = Instruments.Bandmate
GROUP BY FirstName, Instrument)

SELECT FirstName, Instrument, num FROM instCount i1
WHERE num = (select max(num) from instCount i2 where i1.FirstName = i2.FirstName)
ORDER BY FirstName, Instrument;


USE `KATZENJAMMER`;
-- KATZENJAMMER-5
-- Find all instruments played ONLY by Anne-Marit. Report instrument names in alphabetical order.
SELECT Distinct Instrument FROM Instruments
JOIN Band on Band.Id = Instruments.Bandmate
WHERE FirstName = "Anne-Marit" and Instrument NOT IN (select Distinct Instrument from Instruments
join Band on Band.Id = Instruments.Bandmate
WHERE Firstname != "Anne-Marit")
ORDER BY Instrument;


USE `KATZENJAMMER`;
-- KATZENJAMMER-6
-- Report, in alphabetical order, the first name(s) of the performer(s) who played the largest number of different instruments.

WITH instCount as (SELECT FirstName, count(distinct Instrument) as icount FROM Instruments
JOIN Band on Band.Id = Instruments.Bandmate
GROUP BY FirstName)

SELECT FirstName FROM instCount WHERE icount = (select max(icount) from instCount)
ORDER BY FirstName;


USE `KATZENJAMMER`;
-- KATZENJAMMER-7
-- Which instrument(s) was/were played on the largest number of songs? Report just the names of the instruments, sorted alphabetically (note, you are counting number of songs on which an instrument was played, make sure to not count two different performers playing same instrument on the same song twice).
WITH songCount as (SELECT Instrument, count(distinct Song) as songCount FROM Instruments
JOIN Band on Band.Id = Instruments.Bandmate
GROUP BY Instrument)

SELECT Instrument FROM songCount WHERE songCount = (select max(Songcount) from songCount)
ORDER BY Instrument;


USE `KATZENJAMMER`;
-- KATZENJAMMER-8
-- Who spent the most time performing in the center of the stage (in terms of number of songs on which she was positioned there)? Return just the first name of the performer(s), sorted in alphabetical order.

WITH scount as (SELECT FirstName, Count(distinct Song) as songCount from Performance
JOIN Band on Band.Id = Performance.Bandmate
WHERE StagePosition = "center"
GROUP BY FirstName)

SELECT FirstName FROM scount WHERE songCount = (select max(songCount) from scount)
ORDER BY FirstName;


