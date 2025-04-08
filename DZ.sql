--1. Upisati u bazu činjenicu da je 18.05.2011. Robertu Mrkonjiću (robi.mrki@gmail.si) iz Ljubljane 
--izdan račun RN18052011 za troje bijele trkaće čarape veličine M i za 2 naljepnice za bicikl. 
--Na nijedan artikl nije bilo popusta. Kupac je platio gotovinom, a prodaju je napravio novi komercijalist Garfild Mačković.
INSERT INTO Drzava(Naziv) VALUES ('Slovenija')
INSERT INTO Grad SELECT 'Ljubljana', IDDrzava FROM Drzava WHERE Naziv='Slovenija'
INSERT INTO Komercijalist(Ime, Prezime, StalniZaposlenik) VALUES ('Garfild', 'Mačković', 0)
INSERT INTO Kupac([Ime]
      ,[Prezime]
      ,[Email]
      ,[Telefon]
      ,[GradID]) VALUES ('Robert', 'Mrkonjić', 'robi.mrki@gmail.si', NULL, (SELECT IDGrad FROM Grad WHERE Naziv='Ljubljana'))
INSERT INTO Proizvod([Naziv]
      ,[BrojProizvoda]
      ,[Boja]
      ,[MinimalnaKolicinaNaSkladistu]
      ,[CijenaBezPDV]
      ,[PotkategorijaID])
	  VALUES ('Trkaće čarape', 'TC-2659', 'Bijela', 100, 5.99, NULL)
INSERT INTO Proizvod([Naziv]
      ,[BrojProizvoda]
      ,[Boja]
      ,[MinimalnaKolicinaNaSkladistu]
      ,[CijenaBezPDV]
      ,[PotkategorijaID])
	  VALUES ('Naljepnica za bicikl', 'NN-4859', NULL, 1000, 0.99, NULL)
INSERT INTO Racun([DatumIzdavanja]
      ,[BrojRacuna]
      ,[KupacID]
      ,[KomercijalistID]
      ,[KreditnaKarticaID]
      ,[Komentar])
	  VALUES ('20110518', 'RN18052011', 
	  (SELECT IDKupac FROM Kupac WHERE Ime='Robert' AND Prezime='Mrkonjić'), 
	  (SELECT IDKomercijalist FROM Komercijalist WHERE Ime='Garfild' AND Prezime='Mačković'), NULL, NULL)
INSERT INTO Stavka([RacunID]
      ,[Kolicina]
      ,[ProizvodID]
      ,[CijenaPoKomadu]
      ,[PopustUPostocima]
      ,[UkupnaCijena])
	  VALUES (75124, 3, 1001, 5.99, 0, 5.99*3)
INSERT INTO Stavka([RacunID]
      ,[Kolicina]
      ,[ProizvodID]
      ,[CijenaPoKomadu]
      ,[PopustUPostocima]
      ,[UkupnaCijena])
	  VALUES (75124, 2, 
	  (SELECT IDProizvod FROM Proizvod WHERE BrojProizvoda = 'NN-4859'),
	  (SELECT CijenaBezPDV FROM Proizvod WHERE BrojProizvoda = 'NN-4859'), 0, 
	  (SELECT CijenaBezPDV FROM Proizvod WHERE BrojProizvoda = 'NN-4859')*2)


--2. Promijenite u bazi netočan podatak da je gospodin Mrkonjić iz Ljubljane; on je ustvari iz Beča.
INSERT INTO Drzava(Naziv) VALUES ('Austrija')
INSERT INTO Grad SELECT 'Beč', IDDrzava FROM Drzava WHERE Naziv='Austrija'
UPDATE Kupac SET GradID=(SELECT IDGrad FROM Grad WHERE Naziv ='Beč') WHERE Ime='Robert' AND Prezime='Mrkonjić'

--3. Promijenite u bazi netočan podatak da je gospodin Mrkonjić kupio naljepnice; on je ustvari kupio samo čarape.
DELETE FROM Stavka WHERE RacunID=75124 AND ProizvodID=1002

--4. Za sve račune izdane 01.08.2002. i plaćene American Expressom ispisati njihove ID-eve i brojeve te ime i prezime i grad kupca, ime i prezime komercijaliste te broj i podatke o isteku kreditne kartice. Rezultate sortirati prema prezimenu kupca.
SELECT r.IDRacun, kk.Broj AS BrojKartice, kupac.Ime+' '+kupac.Prezime AS KupacImePrezime, g.Naziv AS KupacGrad, 
kom.Ime+' '+kom.Prezime AS KomercijalistImePrezime , 
--kk.IstekMjesec, kk.IstekGodina,
CAST(kk.IstekMjesec AS NVARCHAR(10))+'/'+CAST(kk.IstekGodina AS NVARCHAR(10)) AS IstekKartice
FROM Racun AS r
INNER JOIN KreditnaKartica AS kk ON r.KreditnaKarticaID=kk.IDKreditnaKartica 
INNER JOIN Kupac AS kupac ON kupac.IDKupac=r.KupacID
INNER JOIN Grad AS g ON kupac.GradID=g.IDGrad
INNER JOIN Komercijalist AS kom ON r.KomercijalistID=kom.IDKomercijalist
WHERE r.DatumIzdavanja='20020801' AND kk.Tip='American Express'
ORDER BY kupac.Prezime

--5. Ispisati nazive proizvoda koji su na nekoj stavci računa prodani u više od 35 komada. Svaki proizvod navesti samo jednom.
SELECT DISTINCT p.Naziv FROM Proizvod AS p INNER JOIN Stavka AS s ON p.IDProizvod=s.ProizvodID WHERE s.Kolicina>35

--6. Vratite broj svih proizvoda.
SELECT COUNT(DISTINCT Naziv) AS BrojProizvoda FROM Proizvod

--7. Vratite broj proizvoda koji imaju definiranu boju.
SELECT COUNT(IDProizvod) FROM Proizvod WHERE Boja IS NOT NULL

--8. Vratite najvišu cijenu proizvoda.
SELECT TOP (1) CijenaBezPDV FROM Proizvod ORDER BY CijenaBezPDV DESC
SELECT MAX(CijenaBezPDV) FROM Proizvod

--9. Vratite prosječnu cijenu proizvoda iz potkategorije 16.
SELECT AVG(CijenaBezPDV) AS ProsjecnaCijena FROM Proizvod WHERE PotkategorijaID=16

--10.Vratite datume najstarijeg i najnovijeg računa izdanog kupcu 131. 
SELECT TOP (1) DatumIzdavanja AS Najstariji FROM Racun WHERE KupacID = 131 ORDER BY DatumIzdavanja ASC
SELECT TOP (1) DatumIzdavanja AS Najnoviji FROM Racun WHERE KupacID = 131 ORDER BY DatumIzdavanja DESC
SELECT MAX(DatumIzdavanja) FROM Racun WHERE KupacID=131
SELECT MIN(DatumIzdavanja) FROM Racun WHERE KupacID=131