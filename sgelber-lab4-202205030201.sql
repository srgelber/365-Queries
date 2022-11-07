-- Lab 4
-- sgelber
-- May 3, 2022

USE `STUDENTS`;
-- STUDENTS-1
-- Find all students who study in classroom 111. For each student list first and last name. Sort the output by the last name of the student.
SELECT FirstName, LastName FROM list WHERE classroom = 111 ORDER BY LastName;


USE `STUDENTS`;
-- STUDENTS-2
-- For each classroom report the grade that is taught in it. Report just the classroom number and the grade number. Sort output by classroom in descending order.
SELECT DISTINCT classroom, grade FROM list ORDER BY classroom DESC;


USE `STUDENTS`;
-- STUDENTS-3
-- Find all teachers who teach fifth grade. Report first and last name of the teachers and the room number. Sort the output by room number.
SELECT DISTINCT teachers.First, teachers.Last, list.classroom FROM list JOIN teachers ON list.classroom = teachers.classroom WHERE grade = 5 ORDER BY list.classroom;


USE `STUDENTS`;
-- STUDENTS-4
-- Find all students taught by OTHA MOYER. Output first and last names of students sorted in alphabetical order by their last name.
SELECT DISTINCT list.FirstName, list.LastName FROM list JOIN teachers ON list.classroom = teachers.classroom WHERE teachers.First = 'OTHA' and teachers.Last = 'MOYER' ORDER BY list.LastName;


USE `STUDENTS`;
-- STUDENTS-5
-- For each teacher teaching grades K through 3, report the grade (s)he teaches. Output teacher last name, first name, and grade. Each name has to be reported exactly once. Sort the output by grade and alphabetically by teacher’s last name for each grade.
SELECT DISTINCT teachers.Last, teachers.First, list.grade FROM list JOIN teachers ON list.classroom = teachers.classroom WHERE grade = 0 or grade = 1 or grade = 2 or grade = 3 ORDER BY grade, teachers.Last;


USE `BAKERY`;
-- BAKERY-1
-- Find all chocolate-flavored items on the menu whose price is under $5.00. For each item output the flavor, the name (food type) of the item, and the price. Sort your output in descending order by price.
SELECT Flavor, Food, Price FROM goods WHERE Flavor = 'Chocolate' and Price < 5.00 ORDER BY Price DESC;


USE `BAKERY`;
-- BAKERY-2
-- Report the prices of the following items (a) any cookie priced above $1.10, (b) any lemon-flavored items, or (c) any apple-flavored item except for the pie. Output the flavor, the name (food type) and the price of each pastry. Sort the output in alphabetical order by the flavor and then pastry name.
SELECT Flavor, Food, Price FROM goods WHERE (Food = 'Cookie' and Price > 1.10) or (Flavor = 'Lemon') or (Flavor = 'Apple' and Food != 'Pie') ORDER BY Flavor, Food;


USE `BAKERY`;
-- BAKERY-3
-- Find all customers who made a purchase on October 3, 2007. Report the name of the customer (last, first). Sort the output in alphabetical order by the customer’s last name. Each customer name must appear at most once.
SELECT DISTINCT customers.LastName, customers.FirstName FROM receipts JOIN customers ON receipts.Customer = customers.CId WHERE SaleDate = '2007-10-03' ORDER BY customers.LastName;


USE `BAKERY`;
-- BAKERY-4
-- Find all different cakes purchased on October 4, 2007. Each cake (flavor, food) is to be listed once. Sort output in alphabetical order by the cake flavor.
SELECT DISTINCT goods.Flavor, goods.Food FROM receipts 
JOIN items ON receipts.RNumber = items.Receipt 
JOIN goods ON items.Item = goods.GId
WHERE SaleDate = '2007-10-04' and Food = 'Cake' ORDER BY goods.Flavor;


USE `BAKERY`;
-- BAKERY-5
-- List all pastries purchased by ARIANE CRUZEN on October 25, 2007. For each pastry, specify its flavor and type, as well as the price. Output the pastries in the order in which they appear on the receipt (each pastry needs to appear the number of times it was purchased).
SELECT Flavor, Food, Price FROM receipts
JOIN customers ON receipts.Customer = customers.CId 
JOIN items ON receipts.RNumber = items.Receipt 
JOIN goods ON items.Item = goods.GId
WHERE SaleDate = '2007-10-25' and customers.LastName = 'CRUZEN' and customers.FirstName = 'ARIANE' ORDER BY items.Ordinal;


USE `BAKERY`;
-- BAKERY-6
-- Find all types of cookies purchased by KIP ARNN during the month of October of 2007. Report each cookie type (flavor, food type) exactly once in alphabetical order by flavor.

SELECT Flavor, Food FROM receipts
JOIN customers ON receipts.Customer = customers.CId 
JOIN items ON receipts.RNumber = items.Receipt 
JOIN goods ON items.Item = goods.GId
WHERE Food = 'Cookie' and MONTH(SaleDate) = 10 and YEAR(SaleDate) = 2007
and customers.LastName = 'ARNN' and customers.FirstName = 'KIP' ORDER BY Flavor;


USE `CSU`;
-- CSU-1
-- Report all campuses from Los Angeles county. Output the full name of campus in alphabetical order.
SELECT Campus FROM campuses WHERE County = 'Los Angeles' ORDER BY Campus;


USE `CSU`;
-- CSU-2
-- For each year between 1994 and 2000 (inclusive) report the number of students who graduated from California Maritime Academy Output the year and the number of degrees granted. Sort output by year.
SELECT degrees.year, degrees.degrees FROM campuses 
JOIN degrees ON campuses.Id = degrees.CampusId 
WHERE campus = 'California Maritime Academy' and degrees.year <= 2000 and degrees.year >= 1994
ORDER BY degrees.year;


USE `CSU`;
-- CSU-3
-- Report undergraduate and graduate enrollments (as two numbers) in ’Mathematics’, ’Engineering’ and ’Computer and Info. Sciences’ disciplines for both Polytechnic universities of the CSU system in 2004. Output the name of the campus, the discipline and the number of graduate and the number of undergraduate students enrolled. Sort output by campus name, and by discipline for each campus.
SELECT campuses.Campus, disciplines.Name, discEnr.Gr, discEnr.Ug FROM campuses 
JOIN discEnr ON campuses.Id = discEnr.CampusId
JOIN disciplines ON discEnr.Discipline = disciplines.Id
WHERE (campuses.Campus LIKE '%Poly%') and discEnr.Year = 2004 and (disciplines.Name = 'Mathematics' or disciplines.Name = 'Engineering' or disciplines.Name = 'Computer and Info. Sciences') 
ORDER BY campuses.Campus, disciplines.Name;


USE `CSU`;
-- CSU-4
-- Report graduate enrollments in 2004 in ’Agriculture’ and ’Biological Sciences’ for any university that offers graduate studies in both disciplines. Report one line per university (with the two grad. enrollment numbers in separate columns), sort universities in descending order by the number of ’Agriculture’ graduate students.
SELECT campuses.Campus, disc1.Gr Agriculture, disc2.Gr Biology FROM campuses 
JOIN discEnr disc1 ON campuses.Id = disc1.CampusId
JOIN disciplines disci1 ON disc1.Discipline = disci1.Id

JOIN discEnr disc2 ON campuses.Id = disc2.CampusId
JOIN disciplines disci2 ON disc2.Discipline = disci2.Id

WHERE (disci1.Name = 'Agriculture' and 
disci2.Name = 'Biological Sciences') and 
      (disc1.Gr > 0 and disc2.Gr > 0) and
      (disc1.Year = 2004 and disc2.Year = 2004)
ORDER BY disc1.Gr DESC;


USE `CSU`;
-- CSU-5
-- Find all disciplines and campuses where graduate enrollment in 2004 was at least three times higher than undergraduate enrollment. Report campus names, discipline names, and both enrollment counts. Sort output by campus name, then by discipline name in alphabetical order.
SELECT campuses.Campus, disciplines.Name, discEnr.Ug, discEnr.Gr FROM campuses 
JOIN discEnr ON campuses.Id = discEnr.CampusId
JOIN disciplines ON discEnr.Discipline = disciplines.Id
WHERE (discEnr.Gr >= (discEnr.Ug*3)) and discEnr.Year = 2004 
ORDER BY campuses.Campus, disciplines.Name;


USE `CSU`;
-- CSU-6
-- Report the amount of money collected from student fees (use the full-time equivalent enrollment for computations) at ’Fresno State University’ for each year between 2002 and 2004 inclusively, and the amount of money (rounded to the nearest penny) collected from student fees per each full-time equivalent faculty. Output the year, the two computed numbers sorted chronologically by year.
SELECT enrollments.Year, (enrollments.FTE * fees.fee) as COLLECTED, round(((enrollments.FTE * fees.fee)/faculty.FTE), 2) as 'PER FACULTY' FROM campuses 
JOIN fees ON campuses.Id = fees.CampusId
JOIN enrollments ON campuses.Id  = enrollments.CampusId
JOIN faculty ON campuses.Id = faculty.CampusId
WHERE (enrollments.Year >= 2002 and enrollments.Year <= 2004)
and campuses.Campus = 'Fresno State University' 
and fees.Year = enrollments.Year
and fees.Year = faculty.Year
ORDER BY enrollments.Year;


USE `CSU`;
-- CSU-7
-- Find all campuses where enrollment in 2003 (use the FTE numbers), was higher than the 2003 enrollment in ’San Jose State University’. Report the name of campus, the 2003 enrollment number, the number of faculty teaching that year, and the student-to-faculty ratio, rounded to one decimal place. Sort output in ascending order by student-to-faculty ratio.
SELECT DISTINCT campuses.Campus, enrollments.FTE as STUDENTS, faculty.FTE as Faculty, round(enrollments.FTE/faculty.FTE,1) as RATIO FROM campuses 
JOIN enrollments ON campuses.Id  = enrollments.CampusId
JOIN faculty ON campuses.Id = faculty.CampusId
JOIN enrollments e2
JOIN campuses c2 ON e2.CampusId = c2.Id
WHERE enrollments.Year = 2003
and faculty.Year = enrollments.Year
and c2.Campus = 'San Jose State University'
and enrollments.FTE > e2.FTE
and e2.Year = 2003
ORDER BY RATIO;


USE `INN`;
-- INN-1
-- Find all modern rooms with a base price below $160 and two beds. Report room code and full room name, in alphabetical order by the code.
SELECT RoomCode, RoomName FROM rooms WHERE decor = 'modern' and basePrice < 160 and Beds = 2 ORDER BY RoomCode;


USE `INN`;
-- INN-2
-- Find all July 2010 reservations (a.k.a., all reservations that both start AND end during July 2010) for the ’Convoke and sanguine’ room. For each reservation report the last name of the person who reserved it, checkin and checkout dates, the total number of people staying and the daily rate. Output reservations in chronological order.
SELECT res1.LastName, res1.CheckIn, res2.CheckOut, (res1.Adults + res1.Kids) as Guests, res1.Rate FROM reservations

JOIN reservations res1 ON reservations.CODE = res1.CODE
JOIN reservations res2 ON reservations.CODE = res2.CODE
JOIN rooms ON reservations.Room = rooms.RoomCode

WHERE MONTH(res1.CheckIn) = 7 and YEAR(res1.CheckIn) = 2010
and MONTH(res2.CheckIn) = 7 and YEAR(res2.CheckIn) = 2010
and rooms.RoomName = 'Convoke and sanguine'
ORDER BY res1.CheckIn;


USE `INN`;
-- INN-3
-- Find all rooms occupied on February 6, 2010. Report full name of the room, the check-in and checkout dates of the reservation. Sort output in alphabetical order by room name.
SELECT rooms.RoomName, reservations.CheckIn, reservations.Checkout FROM reservations
JOIN rooms ON reservations.Room = rooms.RoomCode
WHERE CheckIn <= '2010-02-06' and Checkout > '2010-02-06' ORDER BY rooms.RoomName;


USE `INN`;
-- INN-4
-- For each stay by GRANT KNERIEN in the hotel, calculate the total amount of money, he paid. Report reservation code, room name (full), checkin and checkout dates, and the total stay cost. Sort output in chronological order by the day of arrival.

SELECT CODE, rooms.RoomName, CheckIn, Checkout, (Rate * DATEDIFF(Checkout, CheckIn)) as PAID FROM reservations
JOIN rooms ON reservations.Room = rooms.RoomCode
WHERE (LastName = 'KNERIEN' and FirstName = 'GRANT')
ORDER BY CheckIn;


USE `INN`;
-- INN-5
-- For each reservation that starts on December 31, 2010 report the room name, nightly rate, number of nights spent and the total amount of money paid. Sort output in descending order by the number of nights stayed.
SELECT rooms.RoomName, Rate, DATEDIFF(Checkout, CheckIn) as Nights, (Rate * DATEDIFF(Checkout, CheckIn)) as Money FROM reservations
JOIN rooms ON reservations.Room = rooms.RoomCode
WHERE CheckIn = '2010-12-31'
ORDER BY Nights DESC;


USE `INN`;
-- INN-6
-- Report all reservations in rooms with double beds that contained four adults. For each reservation report its code, the room abbreviation, full name of the room, check-in and check out dates. Report reservations in chronological order, then sorted by the three-letter room code (in alphabetical order) for any reservations that began on the same day.
SELECT CODE, rooms.RoomCode, rooms.RoomName, CheckIn, Checkout FROM reservations
JOIN rooms ON reservations.Room = rooms.RoomCode
WHERE Adults = 4 and rooms.bedType = 'Double'
ORDER BY CheckIn, CODE;


USE `MARATHON`;
-- MARATHON-1
-- Report the overall place, running time, and pace of TEDDY BRASEL.
SELECT Place, RunTime, Pace FROM marathon WHERE FirstName = 'TEDDY' and LastName = 'BRASEL';


USE `MARATHON`;
-- MARATHON-2
-- Report names (first, last), overall place, running time, as well as place within gender-age group for all female runners from QUNICY, MA. Sort output by overall place in the race.
SELECT FirstName, LastName, Place, RunTime, GroupPlace FROM marathon
WHERE State = 'MA' and Town = 'QUNICY' and Sex = 'F'
ORDER BY Place;


USE `MARATHON`;
-- MARATHON-3
-- Find the results for all 34-year old female runners from Connecticut (CT). For each runner, output name (first, last), town and the running time. Sort by time.
SELECT FirstName, LastName, Town, RunTime FROM marathon
WHERE State = 'CT' and Sex = 'F' and Age = 34
ORDER BY RunTime;


USE `MARATHON`;
-- MARATHON-4
-- Find all duplicate bibs in the race. Report just the bib numbers. Sort in ascending order of the bib number. Each duplicate bib number must be reported exactly once.
SELECT DISTINCT m1.BibNumber FROM marathon
JOIN marathon m1 ON marathon.BibNumber = m1.BibNumber
WHERE m1.place != marathon.Place
ORDER BY m1.BibNumber;


USE `MARATHON`;
-- MARATHON-5
-- List all runners who took first place and second place in their respective age/gender groups. List gender, age group, name (first, last) and age for both the winner and the runner up (in a single row). Order the output by gender, then by age group.
SELECT marathon.Sex, marathon.AgeGroup, marathon.FirstName, marathon.LastName, marathon.Age, m1.FirstName, m1.LastName, m1.Age FROM marathon
JOIN marathon m1 ON marathon.AgeGroup = m1.AgeGroup
WHERE marathon.GroupPlace = 1 and m1.GroupPlace = 2 and marathon.sex = m1.sex
ORDER BY marathon.sex, marathon.agegroup;


USE `AIRLINES`;
-- AIRLINES-1
-- Find all airlines that have at least one flight out of AXX airport. Report the full name and the abbreviation of each airline. Report each name only once. Sort the airlines in alphabetical order.
SELECT DISTINCT airlines.Name, airlines.Abbr FROM flights
JOIN airlines ON airlines.Id = flights.Airline
WHERE source = 'AXX'
ORDER BY airlines.Name;


USE `AIRLINES`;
-- AIRLINES-2
-- Find all destinations served from the AXX airport by Northwest. Re- port flight number, airport code and the full name of the airport. Sort in ascending order by flight number.

SELECT FlightNo, Destination, airports.Name FROM flights
JOIN airlines ON airlines.Id = flights.Airline
JOIN airports ON flights.destination = airports.Code
WHERE source = 'AXX' and airlines.Abbr = 'Northwest'
ORDER BY FlightNo;


USE `AIRLINES`;
-- AIRLINES-3
-- Find all *other* destinations that are accessible from AXX on only Northwest flights with exactly one change-over. Report pairs of flight numbers, airport codes for the final destinations, and full names of the airports sorted in alphabetical order by the airport code.
SELECT DISTINCT flights.FlightNo, f1.FlightNo, f1.Destination, airports.Name FROM flights
JOIN flights f1 ON f1.source = flights.destination
JOIN airlines ON airlines.Id = flights.Airline and f1.Airline = airlines.Id
JOIN airports ON f1.destination = airports.Code
WHERE flights.source = 'AXX' and airlines.Abbr = 'Northwest'
and f1.destination != 'AXX'
ORDER BY f1.Destination;


USE `AIRLINES`;
-- AIRLINES-4
-- Report all pairs of airports served by both Frontier and JetBlue. Each airport pair must be reported exactly once (if a pair X,Y is reported, then a pair Y,X is redundant and should not be reported).
SELECT DISTINCT f1.Source, f2.Destination FROM flights as f1, flights as f2, airlines as a1, airlines as a2
WHERE a1.Abbr = 'Frontier' and a2.Abbr = 'JetBlue'
and (f1.Source = f2.Source and f1.Destination = f2.Destination)
and a1.Id = f1.Airline and a2.Id = f2.Airline and f1.Source < f2.Destination;


USE `AIRLINES`;
-- AIRLINES-5
-- Find all airports served by ALL five of the airlines listed below: Delta, Frontier, USAir, UAL and Southwest. Report just the airport codes, sorted in alphabetical order.
SELECT DISTINCT Code FROM airports
JOIN flights f1 ON f1.Destination = airports.Code
JOIN airlines a1 ON a1.Id = f1.Airline

JOIN flights f2 ON f2.Destination = airports.Code
JOIN airlines a2 ON a2.Id = f2.Airline

JOIN flights f3 ON f3.Destination = airports.Code
JOIN airlines a3 ON a3.Id = f3.Airline

JOIN flights f4 ON f4.Destination = airports.Code
JOIN airlines a4 ON a4.Id = f4.Airline

JOIN flights f5 ON f5.Destination = airports.Code
JOIN airlines a5 ON a5.Id = f5.Airline

WHERE a1.Abbr = 'Delta' and a2.Abbr = 'Frontier' and a3.Abbr = 'USAir' and
a4.Abbr = 'UAL' and a5.Abbr = 'Southwest'

ORDER BY Code;


USE `AIRLINES`;
-- AIRLINES-6
-- Find all airports that are served by at least three Southwest flights. Report just the three-letter codes of the airports — each code exactly once, in alphabetical order.
SELECT DISTINCT Code from airports

JOIN flights f1 ON airports.Code = f1.Source 
JOIN flights f2 ON airports.Code = f2.Source 
JOIN flights f3 ON airports.Code = f3.Source

JOIN flights f4 ON airports.Code = f4.Destination
JOIN flights f5 ON airports.Code = f5.Destination
JOIN flights f6 ON airports.Code = f6.Destination

JOIN airlines a1 ON f1.Airline = a1.Id
JOIN airlines a2 ON f4.Airline = a2.Id

WHERE a1.Abbr = 'Southwest' and a2.Abbr = 'Southwest'
and (f1.FlightNo != f2.FlightNo and f1.FlightNo != f3.FlightNo)
and (f2.FlightNo != f1.FlightNo and f2.FlightNo != f3.FlightNo)
and (f3.FlightNo != f2.FlightNo and f3.FlightNo != f1.FlightNo)

and (f4.FlightNo != f5.FlightNo and f4.FlightNo != f6.FlightNo)
and (f5.FlightNo != f4.FlightNo and f5.FlightNo != f6.FlightNo)
and (f6.FlightNo != f4.FlightNo and f6.FlightNo != f5.FlightNo)

and (f1.Source = f2.Source and f1.Source = f3.Source)
and (f4.Destination = f5.Destination and f4.Destination = f6.Destination)
and f2.Airline = f1.Airline
and f3.Airline = f1.Airline
and f5.Airline = f4.Airline
and f6.Airline = f4.Airline
ORDER BY Code;


USE `KATZENJAMMER`;
-- KATZENJAMMER-1
-- Report, in order, the tracklist for ’Le Pop’. Output just the names of the songs in the order in which they occur on the album.
SELECT Songs.Title FROM Tracklists
JOIN Albums ON Albums.AId = Tracklists.Album
JOIN Songs ON Songs.SongId = Tracklists.Song
WHERE Albums.Title = 'Le Pop'
ORDER BY Tracklists.Position;


USE `KATZENJAMMER`;
-- KATZENJAMMER-2
-- List the instruments each performer plays on ’Mother Superior’. Output the first name of each performer and the instrument, sort alphabetically by the first name.
SELECT Band.Firstname, Instruments.Instrument FROM Instruments
JOIN Songs ON Songs.SongId = Instruments.Song
JOIN Band ON Instruments.Bandmate = Band.Id
WHERE Songs.Title = 'Mother Superior'
ORDER BY Band.Firstname;


USE `KATZENJAMMER`;
-- KATZENJAMMER-3
-- List all instruments played by Anne-Marit at least once during the performances. Report the instruments in alphabetical order (each instrument needs to be reported exactly once).
SELECT DISTINCT Instruments.Instrument FROM Instruments
JOIN Songs ON Songs.SongId = Instruments.Song
JOIN Band ON Instruments.Bandmate = Band.Id
JOIN Performance ON Performance.Song = Instruments.Song
WHERE Performance.Bandmate = Instruments.Bandmate and Band.Firstname = 'Anne-Marit'
ORDER BY Instruments.Instrument;


USE `KATZENJAMMER`;
-- KATZENJAMMER-4
-- Find all songs that featured ukalele playing (by any of the performers). Report song titles in alphabetical order.
SELECT DISTINCT Songs.Title FROM Instruments
JOIN Songs ON Songs.SongId = Instruments.Song
JOIN Performance ON Performance.Song = Instruments.Song
WHERE Instruments.Instrument = 'ukalele'
ORDER BY Songs.Title;


USE `KATZENJAMMER`;
-- KATZENJAMMER-5
-- Find all instruments Turid ever played on the songs where she sang lead vocals. Report the names of instruments in alphabetical order (each instrument needs to be reported exactly once).
SELECT DISTINCT Instruments.Instrument FROM Instruments
JOIN Songs ON Songs.SongId = Instruments.Song
JOIN Band ON Instruments.Bandmate = Band.Id
JOIN Performance ON Performance.Song = Instruments.Song
JOIN Vocals ON Vocals.Song = Instruments.Song
WHERE Performance.Bandmate = Instruments.Bandmate 
and Vocals.Bandmate = Instruments.Bandmate
and Band.Firstname = 'Turid'
and Vocals.VocalType = 'lead'
ORDER BY Instruments.Instrument;


USE `KATZENJAMMER`;
-- KATZENJAMMER-6
-- Find all songs where the lead vocalist is not positioned center stage. For each song, report the name, the name of the lead vocalist (first name) and her position on the stage. Output results in alphabetical order by the song, then name of band member. (Note: if a song had more than one lead vocalist, you may see multiple rows returned for that song. This is the expected behavior).
SELECT DISTINCT Songs.Title, Band.Firstname, Performance.StagePosition FROM Instruments
JOIN Songs ON Songs.SongId = Instruments.Song
JOIN Band ON Instruments.Bandmate = Band.Id
JOIN Performance ON Performance.Song = Instruments.Song
JOIN Vocals ON Vocals.Song = Instruments.Song
WHERE Performance.Bandmate = Instruments.Bandmate 
and Vocals.Bandmate = Instruments.Bandmate
and Performance.StagePosition != 'center'
and Vocals.VocalType = 'lead'
ORDER BY Songs.Title, Band.Firstname;


USE `KATZENJAMMER`;
-- KATZENJAMMER-7
-- Find a song on which Anne-Marit played three different instruments. Report the name of the song. (The name of the song shall be reported exactly once)
SELECT DISTINCT Songs.Title from Songs

JOIN Instruments I1 ON I1.Song = Songs.SongId
JOIN Band B1 ON I1.Bandmate = B1.Id

JOIN Instruments I2 ON I2.Song = Songs.SongId
JOIN Band B2 ON I2.Bandmate = B2.Id

JOIN Instruments I3 ON I3.Song = Songs.SongId
JOIN Band B3 ON I3.Bandmate = B3.Id

WHERE (I1.Instrument != I2.Instrument and I1.Instrument != I3.Instrument)
and (I2.Instrument != I1.Instrument and I2.Instrument != I3.Instrument)
and (I3.Instrument != I2.Instrument and I3.Instrument != I1.Instrument)
and B1.FirstName = 'Anne-Marit'
and B2.FirstName = 'Anne-Marit'
and B3.FirstName = 'Anne-Marit';


USE `KATZENJAMMER`;
-- KATZENJAMMER-8
-- Report the positioning of the band during ’A Bar In Amsterdam’. (just one record needs to be returned with four columns (right, center, back, left) containing the first names of the performers who were staged at the specific positions during the song).
SELECT B3.FirstName as `RIGHT`, B1.FirstName as CENTER, B4.FirstName as BACK, B2.FirstName as `LEFT`
FROM Songs

JOIN Performance P1 ON P1.Song = Songs.SongId
JOIN Band B1 ON B1.Id = P1.BandMate

JOIN Performance P2 ON P2.Song = Songs.SongId
JOIN Band B2 ON B2.Id = P2.BandMate

JOIN Performance P3 ON P3.Song = Songs.SongId
JOIN Band B3 ON B3.Id = P3.BandMate

JOIN Performance P4 ON P4.Song = Songs.SongId
JOIN Band B4 ON B4.Id = P4.BandMate

WHERE P1.StagePosition = 'center' 
and P2.StagePosition = 'left'
and P3.StagePosition = 'right'
and P4.StagePosition = 'back'
and Songs.Title = "A Bar In Amsterdam";


