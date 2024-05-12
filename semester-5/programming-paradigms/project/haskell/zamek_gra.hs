-- Filip Browarny, Hubert Brzóskniewicz, Paweł Rogóż

import System.IO -- potrzebne
import Text.Read
import Data.Bits
import Control.Monad.State -- potrzebne
import Control.Monad.IO.Class (liftIO)
import Data.List (find)
import System.IO (hFlush, stdout)
import Data.Time
import Control.Monad.Trans.Class (lift)
import System.Random -- potrzebne
import Control.Concurrent -- potrzebne
import Data.Time.Clock.POSIX -- potrzebne
import Control.Monad
import System.CPUTime
import Data.Char
-- zamek krola - opis stanow
-- indeks 0: zakonczone(znalezienie_listu)
-- indeks 1: zakonczone(pokazanie_listu_krolowi)
-- indeks 2: wziete marchewki
-- indeks 3: wziety cukier
-- indeks 4: wybudzilem masztalerza
-- indeks 5: oswoilem konie
-- indeks 6: wybralem konia (fantazje)
-- indeks 7:
-- indeks 8: wzieta woda
-- indeks 25: oswoilem jutrznie
-- indeks 26: oswoilem fantazje
-- indeks 27: oswoilem zefira
-- indeks 28: oswoilem herosa
-- indeks 29: przejazdzka na jutrzni
-- indeks 30: przejazdzka na fantazji
-- indeks 31: przejazdzka na zefirze
-- indeks 32: przejazdzka na herosie
-- 21 podniesienie klucza
-- 22 koniec gry

-- 10 podniesiona rekojesc, 11 otrzymano miecz, 12 otrzymano zbroje, 13 pokonano bandziorow
stan = [False, False, False, False, False, False, False, False, False, False,
    False, False, False, False, False, False, False, False, False, False,
    False, False, False, False, False, False, False, False, False, False,
    False, False, False, False, False, False, False, False, False, False]

wprowadzenie = [
    "Kolejny beztroski dzień w grodzie zamku",
    "Przewracasz się z boku na bok, zastanawiasz się, czy może powinieneś już wstać z łóżka",
    "Nagle słyszysz głośny huk drzwi",
    "Do pokoju wbiega jeden z pracowników dworu",
    "Pracownik: Książe! Wstawaj! Wstawaj!",
    "Ty: Co się stało?",
    "P: Porwano księżniczkę!",
    "T: Co? Jak to?",
    "P: Nie wiem, na dworze jest straszne zamieszanie. Król kazał Cię jak najszybciej wezwać",
    "Wyjdź na korytarz, używając komendy: \"idz korytarz\" i spróbuj znaleźć króla",
    ""
    ]

tekstInstrukcji = [
    "Wprowadzaj komendy używając standardowej składni Haskella.",
    "Dostępne komendy ",
    "idz [miejsce]          -- aby przejść w dane miejsce. ",
    "eq                     -- aby pokazać ekwipunek. ",
    "podnies [przedmiot]    -- aby podnieść przedmiot. ",
    "spojrz                 -- aby rozejrzeć się dookoła. ",
    "instrukcje             -- aby zobaczyć tą wiadomość ponownie. ",
    "ctrl+c                 -- aby zakończyć grę i wyjść."
    ]

type Ekwipunek = [String]
type StanGry = [Bool]
type Lokalizacje = [Lokalizacja]
data Lokalizacja = Lokalizacja { nazwaMiejsca :: String, polaczenia :: [String], przedmioty :: [String] } deriving(Show, Eq)

type Game a = StateT (Lokalizacja, Ekwipunek, StanGry, Lokalizacje) IO a

-- lokalizacje w zamku
sypialniaKsiecia = Lokalizacja "sypialnia_ksiecia" ["korytarz"] ["kapcie"]
korytarz = Lokalizacja "korytarz" ["sypialnia_ksiecia", "brama_zamkowa", "komnata_krola", "pralnia", "zbrojownia", "kuchnia"] ["lampa"]
bramaZamkowa = Lokalizacja "brama_zamkowa" ["korytarz", "przedzamcze"] [""]
przedzamcze = Lokalizacja "przedzamcze" ["brama_zamkowa", "kowal", "stajnia", "droga_do_wroga"] [""]
kuchnia = Lokalizacja "kuchnia" ["korytarz"] ["marchewki", "cukier"]
zbrojownia = Lokalizacja "zbrojownia" ["korytarz"] [""]
pralnia = Lokalizacja "pralnia" ["korytarz"] ["list"]
komnata_krola = Lokalizacja "komnata_krola" ["korytarz"] [""]

-- lokalizacje w stajni
stajnia = Lokalizacja "stajnia" ["przedzamcze", "pokoj", "wybieg", "spichlerz", "konie"] [""]
pokoj = Lokalizacja "pokoj" ["stajnia"] ["woda"]
wybieg = Lokalizacja "wybieg" ["stajnia"] [""]
konie = Lokalizacja "konie" ["stajnia"] [""]
spichlerz = Lokalizacja "spichlerz" ["stajnia"] [""]

kowal = Lokalizacja "kowal" ["przedzamcze", "lada", "skladzik", "kowadlo", "regaly", "szafka"] [""]
lada = Lokalizacja "lada" ["kowal", "skladzik", "szafka"] [""]
skladzik = Lokalizacja "skladzik" ["kowal", "lada", "kowadlo"] ["miotla", "drabina", "wiadro"]
kowadlo = Lokalizacja "kowadlo" ["kowal", "skladzik", "regaly"] [""]
regaly = Lokalizacja "regaly" ["kowal", "kowadlo", "szafka"] [""]
szafka = Lokalizacja "szafka" ["kowal", "regaly", "lada"] ["rekawice", "scierka", "zlota_moneta", "mlotek"]

drogaDoWroga = Lokalizacja "droga_do_wroga" ["przedzamcze", "brama_wroga", "mury_zamku_wroga"] []
bramaWroga = Lokalizacja "brama_wroga" ["droga_do_wroga", "mury_zamku_wroga"] []
muryZamkuWroga = Lokalizacja "mury_zamku_wroga" ["droga_do_wroga", "brama_wroga"] []
wartownia = Lokalizacja "wartownia" ["korytarz_wroga"] [""]
korytarzWroga = Lokalizacja "korytarz_wroga" ["wartownia", "wieza_zamkowa", "lochy"] []
wiezaZamkowa = Lokalizacja "wieza_zamkowa" ["korytarz_wroga", "drzwi"] []
drzwi = Lokalizacja "drzwi" ["wieza_zamkowa"] []
lochy = Lokalizacja "lochy" ["korytarz_wroga"] []


listaLokalizacji = [sypialniaKsiecia,korytarz,bramaZamkowa,przedzamcze,drogaDoWroga, 
                    kuchnia, zbrojownia, pralnia, komnata_krola, stajnia, pokoj, 
                    konie, wybieg, spichlerz,
                    kowal,lada,skladzik,kowadlo,regaly,szafka,bramaWroga, muryZamkuWroga, 
                    wartownia, korytarzWroga, wiezaZamkowa, drzwi, lochy]

zmienStan :: Int -> Bool -> Game ()
zmienStan index wartosc = modify (\(loc, inv, var,locs) -> (loc, inv, updateList index wartosc var,locs))
  where
    updateList :: Int -> a -> [a] -> [a]
    updateList index wartosc list = take index list ++ [wartosc] ++ drop (index + 1) list

getWartoscNaMiejscu :: [Bool] -> Int -> Bool
getWartoscNaMiejscu [] _ = False
getWartoscNaMiejscu (x:xs) index
  | index == 0 = x
  | otherwise = getWartoscNaMiejscu xs (index - 1)

opis :: Lokalizacja -> Game ()
opis l = do
    znalezienie_listu <- gets (\(_, _, var, _) -> getWartoscNaMiejscu var 0)
    pokazanie_listu_krolowi <- gets (\(_, _, var, _) -> getWartoscNaMiejscu var 1)
    wziete_marchewki <- gets (\(_, _, var, _) -> getWartoscNaMiejscu var 2)
    wziety_cukier <- gets (\(_, _, var, _) -> getWartoscNaMiejscu var 3)
    wybudzenie_masztalerza <- gets (\(_, _, var, _) -> getWartoscNaMiejscu var 4)
    nakarmilem_konie <- gets (\(_, _, var, _) -> getWartoscNaMiejscu var 5)
    wybralem_konia <- gets (\(_, _, var, _) -> getWartoscNaMiejscu var 6)
    oswojona_jutrznia <- gets (\(_, _, var, _) -> getWartoscNaMiejscu var 25)
    oswojona_fantazja <- gets (\(_, _, var, _) -> getWartoscNaMiejscu var 26)
    oswojony_zefir <- gets (\(_, _, var, _) -> getWartoscNaMiejscu var 27)
    oswojony_heros <- gets (\(_, _, var, _) -> getWartoscNaMiejscu var 28)
    przejazdzka_jutrznia <- gets (\(_, _, var, _) -> getWartoscNaMiejscu var 29)
    przejazdzka_fantazja <- gets (\(_, _, var, _) -> getWartoscNaMiejscu var 30)
    przejazdzka_zefir <- gets (\(_, _, var, _) -> getWartoscNaMiejscu var 31)
    przejazdzka_heros <- gets (\(_, _, var, _) -> getWartoscNaMiejscu var 32)
    klucz_posiadany <- czyPosiadanyPrzedmiot "klucz"
    wartownik_zabity <- gets (\(_, _, var, _) -> getWartoscNaMiejscu var 21)
    if nazwaMiejsca l == "sypialnia_ksiecia"
        then liftIO $ putStrLn "Jesteś w sypialni księcia"
    else if nazwaMiejsca l == "korytarz"
        then do
            liftIO $ putStrLn "Jesteś w korytarzu"
            liftIO $ putStrLn "Pamiętaj, aby zajrzeć do każdego pokoju w zamku"
            liftIO $ putStrLn "Mogą się w nich znajdować cenne wskazówki i przedmioty,"
            liftIO $ putStrLn "które mogą okazać się niezbędne do wykonania Twoich zadań"
    else if nazwaMiejsca l == "brama_zamkowa"
        then do
            liftIO $ putStrLn "Jesteś w bramie zamkowej"
            if pokazanie_listu_krolowi
                then do
                    liftIO $ putStrLn "Znajdujesz się w bramie zamkowej"
                    liftIO $ putStrLn "Za bramą znajduje się przedzamcze, z którego"
                    liftIO $ putStrLn "możesz udać się do miejsc w okolicy zamku"
                    liftIO $ putStrLn "Na pewno będzie interesować Cię zakład kowala"
                    liftIO $ putStrLn "Zajrzyj też do stajni, aby wziąć konia"
            else do
                liftIO $ putStrLn "W tym momencie gry nie wiesz, jaki jest Twój cel"
                liftIO $ putStrLn "Znajdź list i pokaż go królowi"
                liftIO $ putStrLn "Dopiero wtedy będziesz naprawdę gotowy do rozpoczęcia przygody"
    else if nazwaMiejsca l == "przedzamcze"
        then liftIO $ putStrLn "Jesteś w przedzamczu"
    else if nazwaMiejsca l == "kowal"
        then do
            -- 10 podniesiona rekojesc, 11 otrzymano miecz, 12 otrzymano zbroje
            rekojesc <- gets (\(_, _, var,_) -> getWartoscNaMiejscu var 10)
            miecz <- gets (\(_, _, var,_) -> getWartoscNaMiejscu var 11)
            zbroja <- gets (\(_, _, var,_) -> getWartoscNaMiejscu var 12)
            posiadaRekojesc <- czyPosiadanyPrzedmiot "rekojesc"
            if (rekojesc == False && miecz == False && zbroja == False)
                then do
                    liftIO $ putStrLn "Jesteś u kowala"
                    liftIO $ putStrLn "Zauważasz, że właśnie ciężko pracuje on nad tworzeniem nowego miecza."
                    liftIO $ putStrLn "Może będziesz w stanie uzyskać tutaj potrzebny ekwipunek..."
                    liftIO $ putStrLn "-- aby zacząć rozmowę z kowalem, wpisz \'rozmawiaj\' --"
            else if (rekojesc == True && posiadaRekojesc == True)
                then do
                    liftIO $ putStrLn "Rycerz: Znalazłem rękojeść, której szukałeś."
                    -- usun rekojesc z eq
                    aktualizujEkwipunek (filter (/= "rekojesc"))
                    liftIO $ putStrLn "Kowal: Znakomicie! Wiedziałem, że ci się uda."
                    liftIO $ putStrLn "Kowal: Widzisz, na startośc tak już jest. Zostawiasz gdzieś rzeczy, "
                    liftIO $ putStrLn "       i później sam zapominasz gdzie to się podziało. Bardzo ci dziękuję."
                    liftIO $ putStrLn "Rycerz: Żaden problem."
                    liftIO $ putStrLn "Kowal: Tak jak obiecywałem, przekazuję ci mój stary miecz.\n"
                    liftIO $ putStrLn "** nowy przedmiot w ekwipunku: stary_miecz **\n"
                    -- dodaj miecz
                    aktualizujEkwipunek ("stary_miecz" :)
                    liftIO $ putStrLn "Rycerz: Bardzo ci dziękuję, z pewnością będzie mi dobrze służył."
                    liftIO $ putStrLn "Rycerz: Mam do ciebie jeszcze jedną sprawę. Czy dostanę tutaj też nową zbroję?"
                    liftIO $ putStrLn "Kowal: Oczywiście, mam gotowych kilka kompletów. Właściwie, to mam jeszcze jedną rzecz,"
                    liftIO $ putStrLn "       z którą nie jestem w stanie sobie poradzić. Dotarło do mnie pismo, lecz nic"
                    liftIO $ putStrLn "       z niego nie rozumiem. Wygląda to na zlepek losowych znaków. Może ty coś"
                    liftIO $ putStrLn "       z tego odczytasz...\n"
                    liftIO $ putStrLn "----------------------------------------------------------------------------------"
                    liftIO $ putStrLn "ŚCIŚLE TAJNE"
                    liftIO $ putStrLn "-.. .-. --- --. .. / -.- --- .-- .- .-.. ..- .-.-.- /"
                    liftIO $ putStrLn "... -.- .-..- .- -.. .- -- / -.- --- .-.. . .--- -. . / -....- --.. .- -- ---. .-- .. . -. .. . -....- .-.-.- /"
                    liftIO $ putStrLn "- -.-- -- / .-. .- --.. . -- / .--. --- - .-. --.. . -... ..- .--- ..-.. / -.. .. .- -- . -. - --- .-- .-.- /"
                    liftIO $ putStrLn "-- --- - -.-- -.- ..-.. / .. / --.. .-..- --- - -.-- / -- .. . -.-. --.. .-.-.- /"
                    liftIO $ putStrLn "-.. --- --. .- -.. .- -- -.-- / ... .. ..-.. / .--- .- -.- / --.. .-- -.-- -.- .-.. . .-.-.- /"
                    liftIO $ putStrLn "- .-- ---. .--- / --. .-.-.-"
                    liftIO $ putStrLn "----------------------------------------------------------------------------------\n"
                    liftIO $ putStrLn "-- gdy uporasz się z zagadką, przebywając u kowala wpisz w terminal frazę \'rozwiazanie SŁOWO KLUCZ\' --"
                    -- otrzymano miecz
                    zmienStan 11 True
            else if (miecz == True && zbroja == False)
                then do
                    liftIO $ putStrLn "----------------------------------------------------------------------------------"
                    liftIO $ putStrLn "ŚCIŚLE TAJNE"
                    liftIO $ putStrLn "-.. .-. --- --. .. / -.- --- .-- .- .-.. ..- .-.-.- /"
                    liftIO $ putStrLn "... -.- .-..- .- -.. .- -- / -.- --- .-.. . .--- -. . / -....- --.. .- -- ---. .-- .. . -. .. . -....- .-.-.- /"
                    liftIO $ putStrLn "- -.-- -- / .-. .- --.. . -- / .--. --- - .-. --.. . -... ..- .--- ..-.. / -.. .. .- -- . -. - --- .-- .-.- /"
                    liftIO $ putStrLn "-- --- - -.-- -.- ..-.. / .. / --.. .-..- --- - -.-- / -- .. . -.-. --.. .-.-.- /"
                    liftIO $ putStrLn "-.. --- --. .- -.. .- -- -.-- / ... .. ..-.. / .--- .- -.- / --.. .-- -.-- -.- .-.. . .-.-.- /"
                    liftIO $ putStrLn "- .-- ---. .--- / --. .-.-.-"
                    liftIO $ putStrLn "----------------------------------------------------------------------------------\n"
                    liftIO $ putStrLn "-- gdy uporasz się z zagadką, przebywając u kowala wpisz w terminal frazę \'rozwiazanie SŁOWO KLUCZ\' --"
            else do
                liftIO $ putStrLn "Jesteś u kowala"
    else if nazwaMiejsca l == "lada"
        then liftIO $ putStrLn "Spoglądasz pod ladę, lecz nie zauważasz tu nic ciekawego."
    else if nazwaMiejsca l == "skladzik"
        then do
            liftIO $ putStrLn "Jesteś w składziku."
            liftIO $ putStrLn "Jest tu spory bałagan, lecz zauważasz na wierzchu kilka rzeczy."
    else if nazwaMiejsca l == "kowadlo"
        then do
            liftIO $ putStrLn "Sprawdzasz okolicę obok kowadła."
            liftIO $ putStrLn "Leży tu kilka sprzętów, lecz nie dostrzegasz nic przydatnego."
    else if nazwaMiejsca l == "regaly"
        then do
            rekojesc <- gets (\(_, _, var,_) -> getWartoscNaMiejscu var 10)
            if (rekojesc == True) -- podniesiona rekojesc
                then do
                    liftIO $ putStrLn "Podchodzisz do regałów."
                    liftIO $ putStrLn "Nie ma tutaj już nic interesującego."
            else do
                posiadaDrabine <- czyPosiadanyPrzedmiot "drabina"
                if posiadaDrabine
                    then do
                        liftIO $ putStrLn "Podchodzisz do regałów."
                        liftIO $ putStrLn "Zauważasz rękojeść na najwyższej półce."
                        liftIO $ putStrLn "Aby jej dosięgnąć, wykorzystujesz wcześniej podniesioną drabinę."
                        liftIO $ putStrLn "Stawiasz drabinę obok regału."
                        liftIO $ putStrLn "Po wejściu na nią udaje ci się sięgnąć rękojeść."
                        -- dodaj rekojesc do eq
                        aktualizujEkwipunek ("rekojesc" :)
                        -- wyrzuc drabine
                        aktualizujEkwipunek (filter (/= "drabina"))
                        -- ustaw podniesiona rekojesc na true
                        zmienStan 10 True
                else do
                    liftIO $ putStrLn "Podchodzisz do regałów."
                    liftIO $ putStrLn "Rozglądasz się. Po chwili zauważasz rękojeść."
                    liftIO $ putStrLn "Próbujesz po nią sięgnąć, lecz jest ona dla ciebie za wysoko."
                    liftIO $ putStrLn "Rycerz: Potrzebuję na coś wejść, aby ją sięgnąć..."
    else if nazwaMiejsca l == "szafka"
        then do
            liftIO $ putStrLn "Podchodzisz do szafki w rogu pomieszczenia."
            liftIO $ putStrLn "Otwierasz drzwiczki. W środku znajdujesz kilka rzeczy."
    else if nazwaMiejsca l == "droga_do_wroga"
        then do
            bandziory <- gets (\(_, _, var,_) -> getWartoscNaMiejscu var 13) -- zakonczone bandziory
            moneta <- czyPosiadanyPrzedmiot "zlota_moneta" -- czy moneta w eq
            if (bandziory == True)
                then do
                    liftIO $ putStrLn "Jesteś w drodze do wroga"
            else do
                liftIO $ putStrLn "Jesteś w drodze do wroga."
                liftIO $ putStrLn "Jedziesz spokojnie na koniu, aż nagle zauważasz w oddali 3 osoby."
                liftIO $ putStrLn "Blokują ci drogę, jesteś zmuszomny do konfrontacji.\n"
                liftIO $ putStrLn "Bandzior1: Hola hola, dokąd to."
                liftIO $ putStrLn "Bandzior2: Myślałeś, że przejedziesz sobie tędy bezproblemowo?"
                liftIO $ putStrLn "           Grubo się myliłeś."
                liftIO $ putStrLn "Bandzior3: Tylko nie próbuj żadnych sztuczek!\n"
                liftIO $ putStrLn "-- Bandzior3 wyciąga włócznię --\n"
                liftIO $ putStrLn "Rycerz: Witajcie panowie, nie szukam żadnych problemów!"
                liftIO $ putStrLn "        Na pewno jakoś się dogadamy."
                liftIO $ putStrLn "Bandzior1: Wyskakuj lepiej ze swoich kosztowności.\n"
                liftIO $ putStrLn "-- Bandzior z włócznią zbliża się do ciebie --\n"
                if (moneta == True)
                    then do
                        liftIO $ putStrLn "Rycerz: Spokojnie, spokojnie!\n"
                        liftIO $ putStrLn "Z wartościowych rzeczy posiadasz jedynie złotą monetę,"
                        liftIO $ putStrLn "być może uda ci się przy jej pomocy wydostać z tarapatów...\n"
                        liftIO $ putStrLn "Czy chcesz oddać bandziorom złotą monetę? (t/n)"
                        --wczytaj znak i rozgalezienie wyboru
                        wybor <- liftIO getLine
                        if (wybor == "t")
                            then do
                                liftIO $ putStrLn "Rycerz: Proszę, oto wszystko co mam.\n"
                                liftIO $ putStrLn "-- podaje złotą monetę --\n"
                                -- oddaj monete z eq
                                aktualizujEkwipunek (filter (/= "zlota_moneta"))
                                liftIO $ putStrLn "Bandzior1: No proszę, czyli faktycznie dało się dogadać."
                                liftIO $ putStrLn "           A teraz zjeżdzaj stąd i nie pojawiaj się tu więcej!"
                                -- zakonczone bandziory na True
                                zmienStan 13 True
                        else do
                            liftIO $ putStrLn "Rycerz: Po moim trupie, niczego wam nie oddam!\n"
                            liftIO $ putStrLn "-- wyciągasz miecz i rozpoczynasz walkę z bandziorami --\n"
                            zagraj
                else do
                    liftIO $ putStrLn "Rycerz: Po moim trupie, niczego wam nie oddam!\n"
                    liftIO $ putStrLn "-- wyciągasz miecz i rozpoczynasz walkę z bandziorami --\n"
                    zagraj
    else if nazwaMiejsca l == "kuchnia"
        then do
            liftIO $ putStrLn "Jesteś w kuchni"
            if wziete_marchewki && wziety_cukier
                then do
                    liftIO $ putStrLn "Kucharka przygotowuje obiad"
                    liftIO $ putStrLn "Kucharka: Po co tu znów przychodzisz?"
                    liftIO $ putStrLn "Ty: Szukam wskazówek..."
                    liftIO $ putStrLn "K: Czy ja wyglądam na kogoś, kto może Ci z tym pomóc?"
                    liftIO $ putStrLn "   Nie zawracaj mi i sobie głowy. Wychodź!"
            else do
                liftIO $ putStrLn "Jesteś w kuchni"
                liftIO $ putStrLn "Kucharka: Co się dzieje w zamku? Czy już wiesz, co się stało?"
                liftIO $ putStrLn "Ty: Pracuję nad tym."
                liftIO $ putStrLn "W rogu pokoju znajduje się sterta marchewek i cukier."
                liftIO $ putStrLn "Mogą się przydać na później"
    else if nazwaMiejsca l == "zbrojownia"
        then do
            liftIO $ putStrLn "Jesteś w zbrojowni"
            liftIO $ putStrLn "Pracownik zbrojowni: Co Ty tu jeszcze robisz? Znajdź księżniczkę, a nie szlajaj się po zamku!"
    else if nazwaMiejsca l == "pralnia"
        then do
            liftIO $ putStrLn "Jesteś w pralni"
            if znalezienie_listu
                then do
                    liftIO $ putStrLn "Służąca: Czego tu jeszcze szukasz?"
                    liftIO $ putStrLn "S: Czas jest teraz bardziej niż cenny, musisz się spieszyć"
            else do
                    liftIO $ putStrLn "Jesteś w pralni"
                    liftIO $ putStrLn "Służąca: Doszły do mnie wieści. Jak czuje się król?"
                    liftIO $ putStrLn "Ty: Nie najlepiej. Sprzątałaś może dziś w jego pokoju?"
                    liftIO $ putStrLn "S: Oczywiście, jak codziennie. Mnóstwo babilotów i papierów, miałam dziś dużo pracy"
                    liftIO $ putStrLn "T: Gdzie są te papiery?"
                    liftIO $ putStrLn "S: Właśnie miałam je spalić, są w rogu pokoju"
                    liftIO $ putStrLn "T: Muszę się im przyjrzeć"
    else if nazwaMiejsca l == "komnata_krola"
        then do
            liftIO $ putStrLn "Jesteś w komnacie króla"
            if pokazanie_listu_krolowi
                then do
                    liftIO $ putStrLn "Król: Czego tu jeszcze szukasz?"
                    liftIO $ putStrLn "Król: Znajdź moją córkę!"
            else if znalezienie_listu
                then do
                    liftIO $ putStrLn "Król: I jak? Znalazłeś już list?"
                    liftIO $ putStrLn "Ty: Tak, zobacz go proszę"
                    liftIO $ putStrLn "*pokazujesz list królowi*"
                    liftIO $ putStrLn "K: MK? To nie może być..."
                    liftIO $ putStrLn "T: Kto to jest?"
                    liftIO $ putStrLn "K: To mój brat. Zawsze był zazdrosny o potęgę mojego królestwa."
                    liftIO $ putStrLn "T: Czego on chce?"
                    liftIO $ putStrLn "K: Nie wiem, ale musisz go powstrzymać. Nie pozwolę, aby zrobił krzywdę mojej córce."
                    liftIO $ putStrLn "   Jego zamek znajduje się na północy. Potrzebujesz konia, żeby tam dotrzeć."
                    liftIO $ putStrLn "   Nasze grody od dawna za sobą nie przepadają. Nie będzie to łatwe zadanie"
                    liftIO $ putStrLn "   Musisz się też uzbroić. Idź do kowala, znajdziesz go w przedzamczu."
                    liftIO $ putStrLn "T: Oczywiście. Królu, obiecuję, że przyprowadzę księżniczkę z powrotem."
                    zmienStan 1 True
            else do
                    liftIO $ putStrLn "Otwierasz drzwi do komnaty króla"
                    liftIO $ putStrLn "Słyszysz dobiegający z wnętrza dźwięk szlochania"
                    liftIO $ putStrLn "Wchodzisz do środka i widzisz króla, który zapłakany siedzi na tronie"
                    liftIO $ putStrLn "Ty: Królu! Co się stało?"
                    liftIO $ putStrLn "Król: Porwano moją córkę!"
                    liftIO $ putStrLn "T: Co? Jak to?"
                    liftIO $ putStrLn "K: Nie wiem, jak to się stało. Wszystko działo się tak szybko."
                    liftIO $ putStrLn "   Wszystko, co wiem, to to, że w komnacie znalazłem list"
                    liftIO $ putStrLn "   Jest w rogu pokoju, weź go i przeczytaj"
                    liftIO $ putStrLn "   Zrób wszystko, co w Twojej mocy, aby ją odnaleźć"
                    liftIO $ putStrLn "T: Nie widzę tutaj żadnego listu"
                    liftIO $ putStrLn "K: O nie! Była tu rano sprzątaczka, pewnie go wzięła."
                    liftIO $ putStrLn "   Musisz ją znaleźć. Na pewno jest gdzieś w zamku"
    else if nazwaMiejsca l == "stajnia"
        then do
            liftIO $ putStrLn "Jesteś w stajni"
            if wybralem_konia
                then do
                    liftIO $ putStrLn "W stajni nie ma już nic ciekawego"
                    liftIO $ putStrLn "Wybrałeś konia, pora zająć się następnymi zadaniami"
                    liftIO $ putStrLn "No już, opuszczaj pokój - czas jest cenny!"
            else if wybudzenie_masztalerza
                then do
                    liftIO $ putStrLn "Masztalerz otworzył ci drzwi - możesz już przejść do pokoju z końmi"
            else do
                liftIO $ putStrLn "Otwierasz drzwi stajni"
                liftIO $ putStrLn "Rozglądasz się dookoła i nie widzisz nikogo."
                liftIO $ putStrLn "Drzwi do pokoju, w którym znajdują się konie, są zamknięte"
                liftIO $ putStrLn "Udaj się do pokoju masztalerza, on pomoże Ci je otworzyć"
    else if nazwaMiejsca l == "pokoj"
        then do
            if wybudzenie_masztalerza
                then do
                    liftIO $ putStrLn "Masztalerz śpi"
                    liftIO $ putStrLn "Nie będziemy go wybudzać, to za ciężkie..."
                    liftIO $ putStrLn "Wróć do stajni"
            else do
                liftIO $ putStrLn "Wchodzisz do pokoju masztalerza. Co on robi?"
                liftIO $ putStrLn "Oczywiście - śpi. Jak zwykle..."
                liftIO $ putStrLn "Ty: Wstawaj! Pobudka! Potrzebuję Cię!"
                liftIO $ putStrLn "Ani drgnie. Jest znany w całym grodzie ze swojego głębokiego snu"
                liftIO $ putStrLn "Aby spróbować go obudzić, użyj komendy \'obudz\'"
    else if nazwaMiejsca l == "konie"
        then do
            liftIO $ putStrLn "Jesteś w stajni konnej"
            if wybralem_konia
                then do
                    liftIO $ putStrLn "Masz już konia, możesz więc opuścić teren stajni"
                    liftIO $ putStrLn "Nie znajdziesz tu już nic więcej"
            else if przejazdzka_fantazja && przejazdzka_heros && przejazdzka_jutrznia && przejazdzka_zefir
                then do
                    liftIO $ putStrLn "Musisz teraz wybrać najszybszego konia"
                    liftIO $ putStrLn "No dalej, nie ma czasu do stracenia!"
                    liftIO $ putStrLn "Użyj komendy \'wybierz imieKonia\', aby wybrać"
            else if oswojona_fantazja && oswojona_jutrznia && oswojony_heros && oswojony_zefir
                then do
                    liftIO $ putStrLn "Musisz teraz przejechać się na każdym z koni, aby wybrać najszybszego"
                    liftIO $ putStrLn "Używaj komendy \'jedz imieKonia\', aby jeździć na danym koniu"
            else do
                liftIO $ putStrLn "Znajdujesz się teraz w pokoju konnym"
                liftIO $ putStrLn "Problem jest taki, że konie się Ciebie boją"
                liftIO $ putStrLn "Musisz je jakoś do siebie przekonać"
                liftIO $ putStrLn "Jedne konie lubią marchewkę, inne cukier"
                liftIO $ putStrLn "Musisz je nakarmić ich ulubionym pokarmem, aby chciały z Tobą współpracować"
                liftIO $ putStrLn "Aby nakarmić konia, użyj komendy \'nakarm imię_konia marchewki/cukier)\'"
                liftIO $ putStrLn "Jeśli nie masz tych pokarmów, musisz wrócić do zamkowej kuchni i je zdobyć"
                liftIO $ putStrLn "Przydatną komendą w tym miejscu będzie komenda \'spójrz\'"
                liftIO $ putStrLn "Używaj jej często, a będziesz dostawał instrukcję na temat tego, co robić"
                liftIO $ putStrLn ""
                liftIO $ putStrLn "Imiona koni:"
                liftIO $ putStrLn "jutrznia"
                liftIO $ putStrLn "fantazja"
                liftIO $ putStrLn "heros"
                liftIO $ putStrLn "zefir"
    else if nazwaMiejsca l == "spichlerz"
        then do
            liftIO $ putStrLn "Jesteś w spichlerzu"
            liftIO $ putStrLn "Nie ma tu nic ciekawego"
    else if nazwaMiejsca l == "wybieg"
        then do
            liftIO $ putStrLn "Jesteś na wybiegu konnym"
            liftIO $ putStrLn "Nie ma tu nic ciekawego"
    else if nazwaMiejsca l == "brama_wroga"
        then do
            liftIO $ putStrLn "Dotarłeś do bramy wroga."
            liftIO $ putStrLn "Niestety bramy pilnuje wielu uzbrojonych żołnierzy,"
            liftIO $ putStrLn "a na murach dostrzegasz łuczników."
            liftIO $ putStrLn "Przejście tędy nie wchodzi w grę, musisz znaleźć inną drogę."
    else if nazwaMiejsca l == "mury_zamku_wroga"
        then do
            liftIO $ putStrLn "Dostrzegasz możliwość dostania się do środka."
            liftIO $ putStrLn "Żołnierzom patrolującym mury zajmuje około 10 minut zrobienie okrążenia."
            liftIO $ putStrLn "Jeśli wykażesz się odpowiednią zwinnością oraz szybkością,"
            liftIO $ putStrLn "Powinno udać ci się wspiąć na mury nie zauważonym."
            liftIO $ putStrLn "Aby przejść dalej musisz wykazać się dobrym wyczuciem czasu."
            liftIO $ putStrLn "Wpisz \'wspinaczka\' aby rozpocząć grę."
    else if nazwaMiejsca l == "wartownia"
        then do
            if (wartownik_zabity) == False
                then do
                    liftIO $ putStrLn "Po wejściu do wartowni dostrzegasz żołnierza z pękiem kluczy przy pasie."
                    liftIO $ putStrLn "Niestety on także ciebie zauwarzył i zaczyna wyciągać swój miecz."
                    liftIO $ putStrLn "Pokonaj go aby zdobyc klucze."
                    liftIO $ putStrLn "Ta mini gra sprawdzi twoją zręczność, a także prędkość."
                    liftIO $ putStrLn "Wpisz \'walcz\', aby rozpocząć grę."
            else if klucz_posiadany == False
                then do
                    liftIO $ putStrLn "Na ziemi leży martwy wartownik"
                    liftIO $ putStrLn "A przy jego pasie wisi przypięty pęk kluczy."
                    liftIO $ putStrLn "Wpisz \'podnies klucz\', aby je podnieść."
            else do
                liftIO $ putStrLn "W twoim ekwipunku znajduje sie klucz."
                liftIO $ putStrLn "Na ziemi leży martwy wartownik"
                liftIO $ putStrLn "Wykazałeś się dużymi umiejętnościami pokonując go."
    else if nazwaMiejsca l == "korytarz_wroga"
        then do
            liftIO $ putStrLn "Udało ci się dostać do środka zamku, w którym uwięziona jest księżniczka."
            liftIO $ putStrLn "Twoim kolejnym zadaniem jest znalezienie jej."
    else if nazwaMiejsca l == "wieza_zamkowa"
        then do
            liftIO $ putStrLn "Po długiej wspinaczce docierasz na szczyt wieży zamkowej."
            liftIO $ putStrLn "Dostrzegasz drzwi."
    else if nazwaMiejsca l == "drzwi"
        then do
            if klucz_posiadany
                then do
                    zmienStan 22 True
                    liftIO $ putStrLn "Próbujesz otworzyć drzwi kluczem zabranym wartownikowi,"
                    liftIO $ putStrLn "całe szczęście, klucz pasuje, udaje ci się otworzyć drzwi."
                    liftIO $ putStrLn "Na łóżku w ciemnym pomieszczeniu dostrzegasz księżniczkę."
                    liftIO $ putStrLn "Gratulacje wygrałeś!"
                    liftIO $ putStrLn "         .* *.               `o`o`"
                    liftIO $ putStrLn "         *. .*              o`o`o`o      ^,^,^"
                    liftIO $ putStrLn "           * \\               `o`o`     ^,^,^,^,^"
                    liftIO $ putStrLn "              \\     ***        |       ^,^,^,^,^"
                    liftIO $ putStrLn "               \\   *****       |        /^,^,^"
                    liftIO $ putStrLn "                \\   ***        |       /"
                    liftIO $ putStrLn "    ~@~*~@~      \\   \\         |      /"
                    liftIO $ putStrLn "  ~*~@~*~@~*~     \\   \\        |     /"
                    liftIO $ putStrLn "  ~*~@smd@~*~      \\   \\       |    /     #$#$#        .`\'.;."
                    liftIO $ putStrLn "  ~*~@~*~@~*~       \\   \\      |   /     #$#$#$#   00  .`,.\',"
                    liftIO $ putStrLn "    ~@~*~@~ \\        \\   \\     |  /      /#$#$#   /|||  `.,\'"
                    liftIO $ putStrLn "_____________\\________\\___\\____|_/______/_________|\\/\\___||______"               
            else do
                liftIO $ putStrLn "Próbujesz otworzyć drzwi, niestety są zamknięte."
                liftIO $ putStrLn "Musisz znaleźć klucz."
    else if nazwaMiejsca l == "lochy"
        then do
            liftIO $ putStrLn "Schodzisz do lochów."
            liftIO $ putStrLn "Masz szczęście, żołnierz który pilnuje lochu śpi na warcie."
            liftIO $ putStrLn "Patrzysz kto znajduje się w celach, natomiast nigdzie nie ma księżniczki."
            liftIO $ putStrLn "Nawet tak zły król, jak władca tego zamku nie wtrąciłby księżniczki do lochów."
    else do
        liftIO $ putStrLn "Jesteś w nieznanym miejscu"
    
    koniec_gry <- gets (\(_, _, var, _) -> getWartoscNaMiejscu var 22)
    if koniec_gry == False then do
        obecnaLokalizacja <- getObecnaLokalizacja
    --  przedmioty
        liftIO $ putStrLn "\nPrzedmioty w lokacji:"
        obiektyWLokalizacji <- getObiektyWLokalizacji obecnaLokalizacja
        liftIO $ putStrLn $ show obiektyWLokalizacji

    --  polaczenia
        liftIO $ putStrLn "\nZ tego miejsca możesz pójść do:"
        sciezki <- getSciezkiZLok obecnaLokalizacja
        liftIO $ putStrLn $ show sciezki
    else do
        liftIO $ putStrLn ""

wspinaczka:: Game()
wspinaczka = do
    lok <- getObecnaLokalizacja
    if nazwaMiejsca lok== "mury_zamku_wroga"
        then do 
            liftIO $ putStrLn "Gdy naciśniesz enter czas zacznie się odmierzać,"
            liftIO $ putStrLn "naciśnij go po raz kolejny po upływie 10 sekund, aby wygrać."
            liftIO $ putStrLn "Możesz pomylić się o sekundę"
            _ <- liftIO getLine
            liftIO $ putStr "start"
            liftIO $ hFlush stdout
            t1 <- liftIO getCurrentTime
            _ <- liftIO getLine
            liftIO $ hFlush stdout
            liftIO $ putStr "stop"
            liftIO $ putStr ""
            t2 <- liftIO getCurrentTime
            let time = diffUTCTime t2 t1
            liftIO $ putStrLn $ "Twój czas: " ++ show time ++ " sekund"
            if time < 11 && time > 9 then do
                liftIO $ putStr "Gratulacje, wygrałeś!"
                obecneLokalizacje <- getListaLokalizacji
                let nowaLokalizacja = getLokalizacjaPoNazwie "korytarz_wroga" obecneLokalizacje
                zmienLokalizacje (const nowaLokalizacja)
                opis nowaLokalizacja
            else do
                liftIO $ putStr "Porażka, spróbuj jeszcze raz!"
    else do
        liftIO $ putStrLn "Nie cwaniakuj mi tu."
        liftIO $ putStrLn "Tej mini gry nie mozesz rozpoczac w tym miejscu."

generujLosowyNapis :: StateT (Lokalizacja, Ekwipunek, StanGry, Lokalizacje) IO String
generujLosowyNapis = do
    gen <- liftIO newStdGen
    let litery = ['a'..'z']
        losoweZnaki = take 25 (randomRs ('a', 'z') gen)
    return $ map (\znak -> litery !! (ord znak - ord 'a')) losoweZnaki

walcz :: Game ()
walcz = do
  
  liftIO $ putStrLn "Gdy naciśniesz enter zostanie wygenerowany losowy napis o długości 25 znaków,"
  liftIO $ putStrLn "a czas zacznie się odmierzać,"
  liftIO $ putStrLn "twoim zadaniem jest przepisanie tego wyrazu oraz naciśnięcie klawisza enter."
  liftIO $ putStrLn "Masz na to 20 sekund. Powodzenia!"

  _ <- liftIO getLine
  liftIO $ putStr "start\n"
  randomString <- generujLosowyNapis
  liftIO $ putStrLn randomString
  
  t1 <- liftIO getCurrentTime
  
  userTypedString <- liftIO getLine
  
  t2 <- liftIO getCurrentTime
  
  let time = diffUTCTime t2 t1
  
  if userTypedString == randomString && time <= 20.0
    then do 
        liftIO $ putStrLn $ "Gratulacje! Udało się w czasie " ++ show time ++ " sekund."
        lok <- getObecnaLokalizacja
        zmienStan 21 True
        opis lok
    else do 
        liftIO $ putStrLn "Czas minął lub tekst nieprawidłowy."
        liftIO $ putStrLn "Wpisz \'walcz\', aby rozpocząć grę."
  
  

podniesKlucz:: String -> Game()
podniesKlucz f = do
    obecnaLokalizacja <- getObecnaLokalizacja
    wartownik_zabity <- gets (\(_, _, var, _) -> getWartoscNaMiejscu var 21)
    if (nazwaMiejsca obecnaLokalizacja == "wartownia" && wartownik_zabity) then do
        aktualizujEkwipunek (f :)
        opis obecnaLokalizacja
    else if (nazwaMiejsca obecnaLokalizacja == "wartownia" && wartownik_zabity == False) then do
        liftIO $ putStrLn "Klucza broni potezny wartownik, musisz go pokonac."
    else do
        liftIO $ putStrLn "Nie cwaniakuj mi tu."
        liftIO $ putStrLn "W tym pomieszczeniu nie ma żadnego klucza."

obudz :: Game()
obudz = do
    obecnaLokalizacja <- getObecnaLokalizacja
    wybudzenie_masztalerza <- gets (\(_, _, var, _) -> getWartoscNaMiejscu var 6)
    wzieta_woda <- gets (\(_, _, var, _) -> getWartoscNaMiejscu var 8)
    if nazwaMiejsca obecnaLokalizacja == "pokoj"
        then do
            if wybudzenie_masztalerza
                then do
                    liftIO $ putStrLn "Masztalerz został juz wybudzony"
            else if wzieta_woda
                then do
                    liftIO $ putStrLn "Masz już wodę, teraz niestety przychodzi gorsza część zadania"
                    liftIO $ putStrLn "Musisz oblać ją masztalerza..."
                    liftIO $ putStrLn "Wpisz komendę \'oblej\', aby to zrobić"
            else do
                liftIO $ putStrLn "Weź wodę połozoną w kącie pokoju (komenda podnies woda)"
                liftIO $ putStrLn "Wykorzystasz ją do polania masztalerza"
                liftIO $ putStrLn "Niestety, to jedyny znany sposób, w jaki udało się go kiedykolwiek wybudzić"
                liftIO $ putStrLn "Kiedy już będziesz ją miał, ponownie wpisz komendę \'obudz\'"
    else do
        liftIO $ putStrLn "Tej komendy możesz użyć tylko będąc w pokoju masztalerza"

oblej :: Game ()
oblej = do
    obecnaLokalizacja <- getObecnaLokalizacja
    wybudzenie_masztalerza <- gets (\(_, _, var, _) -> getWartoscNaMiejscu var 6)
    wzieta_woda <- gets (\(_, _, var, _) -> getWartoscNaMiejscu var 8)
    if nazwaMiejsca obecnaLokalizacja == "pokoj"
        then do
            if wzieta_woda
                then do
                    liftIO $ putStrLn "Kiedy klikniesz enter, polejesz wodą masztalerza"
                    liftIO $ putStrLn "Rób to tak długo, jak długo będzie pozostawał w śnie"
                    liftIO $ putStrLn "Kliknij \'enter\'"
                    _ <- liftIO getLine
                    liftIO $ putStrLn "Ani drgnie! Spróbuj jeszcze raz!"
                    _ <- liftIO getLine
                    liftIO $ putStrLn "Wciąż śpi? Jak to w ogóle jest możliwe?"
                    _ <- liftIO getLine
                    liftIO $ putStrLn "No dobra, ostatnia szansa!"
                    _ <- liftIO getLine
                    liftIO $ putStrLn "Masztalerz: CO TY ROBISZ?!"
                    liftIO $ putStrLn "Ty: Księżniczka została porwana! Potrzebuję jednego ze stajennych koni"
                    liftIO $ putStrLn "M: Kto ją porwał?"
                    liftIO $ putStrLn "T: Brat króla, MK"
                    liftIO $ putStrLn "M: O nie!"
                    liftIO $ putStrLn "   Sytuacja nie będzie prosta. Potrzebujesz najszybszego z naszych koni. Ale.."
                    liftIO $ putStrLn "   Nie do końca wiem, który jest najszybszy. Musisz je przetestować"
                    liftIO $ putStrLn "   Chodź, otworzę ci stajnię"
                    liftIO $ putStrLn "*masztalerz otwiera drzwi do stajni*"
                    liftIO $ putStrLn "M: Sytuacja jest ciężka, to prawda. Ale szczerze?"
                    liftIO $ putStrLn "   Co jak co, ale ja wciąż jestem śpiący. Idź, dasz radę sobie sam"
                    liftIO $ putStrLn "   Powodzenia!"
                    liftIO $ putStrLn "Drzwi do stajni są teraz otwarte, idź i przetestuj konie"
                    zmienStan 4 True
            else do
                liftIO $ putStrLn "Potrzebujesz wody, aby obudzić masztalerza"
    else do
       liftIO $ putStrLn "Tą komendę możesz wywołać tylko w pokoju masztalerza"

nakarm :: String -> String -> Game ()
nakarm imieKonia nazwaPrzedmiotu = do
    obecnaLokalizacja <- getObecnaLokalizacja
    wziete_marchewki <- gets (\(_, _, var, _) -> getWartoscNaMiejscu var 2)
    wziety_cukier <- gets (\(_, _, var, _) -> getWartoscNaMiejscu var 3)
    if nazwaMiejsca obecnaLokalizacja == "konie" && wziete_marchewki && wziety_cukier
        then do
            case (imieKonia, nazwaPrzedmiotu) of
                ("zefir", "cukier") -> do
                    liftIO $ putStrLn "Udało się! To ulubiony pokarm Zefira!"
                    liftIO $ putStrLn "Zdecydowanie Cię polubił"
                    zmienStan 27 True
                ("jutrznia", "marchewki") -> do
                    liftIO $ putStrLn "Udało się! To ulubiony pokarm Jutrznii!"
                    liftIO $ putStrLn "Zdecydowanie Cię polubiła"
                    zmienStan 25 True
                ("heros", "cukier") -> do
                    liftIO $ putStrLn "Udało się! To ulubiony pokarm Herosa!"
                    liftIO $ putStrLn "Zdecydowanie Cię polubił"
                    zmienStan 28 True
                ("fantazja", "marchewki") -> do
                    liftIO $ putStrLn "Udało się! To ulubiony pokarm Fantazji!"
                    liftIO $ putStrLn "Zdecydowanie Cię polubiła"
                    zmienStan 26 True
                _ -> do
                    liftIO $ putStrLn "To nie jest ulubiony smakołyk tego konia. Spróbuj jeszcze raz"
                    liftIO $ putStrLn "Dodatkowo sprawdź poprawność wpisanej komendy"
    else do
        liftIO $ putStrLn "Tej komendy możesz użyć tylko w lokalizacji \'konie\', mając marchewki i cukier"
        liftIO $ putStrLn "Jeśli nie masz marchewek lub cukru, wróć do zamkowej kuchni, aby je zdobyć"

jedz :: String -> Game ()
jedz imieKonia = do
    obecnaLokalizacja <- getObecnaLokalizacja
    oswojona_jutrznia <- gets (\(_, _, var, _) -> getWartoscNaMiejscu var 25)
    oswojona_fantazja <- gets (\(_, _, var, _) -> getWartoscNaMiejscu var 26)
    oswojony_zefir <- gets (\(_, _, var, _) -> getWartoscNaMiejscu var 27)
    oswojony_heros <- gets (\(_, _, var, _) -> getWartoscNaMiejscu var 28)
    if nazwaMiejsca obecnaLokalizacja == "konie"
        then do
            if oswojona_jutrznia && oswojona_fantazja && oswojony_zefir && oswojony_heros
                then do
                    case (imieKonia) of
                        ("zefir") -> do
                            liftIO $ putStrLn "Nie jest ani źle, ani dobrze..."
                            liftIO $ putStrLn "Przejechałeś na nim tor obok stajni w: 20 sekund!"
                            zmienStan 31 True
                        ("fantazja") -> do
                            liftIO $ putStrLn "Czy ty w ogólne zdążyłeś na niego wsiąść?!"
                            liftIO $ putStrLn "Przejechałeś na nim tor obok stajni w: 6 sekund!"
                            zmienStan 30 True
                        ("jutrznia") -> do
                            liftIO $ putStrLn "Co on taki wolny?"
                            liftIO $ putStrLn "Przejechałeś na nim tor obok stajni w: 40 sekund!"
                            zmienStan 29 True
                        ("heros") -> do
                            liftIO $ putStrLn "Wow, ale on jest szybki."
                            liftIO $ putStrLn "Przejechałeś na nim tor obok stajni w: 10 sekund!"
                            zmienStan 32 True
                        _ -> do
                            liftIO $ putStrLn "Nieznana komenda"
            else do
                liftIO $ putStrLn "Musisz oswoić wszystkie konie, zanim zaczniesz jeździć na którymś z nich"
    else do
        liftIO $ putStrLn "Tej komendy możesz użyć tylko w lokalizacji \'konie\'"

wybierz :: String -> Game ()
wybierz imieKonia = do
    obecnaLokalizacja <- getObecnaLokalizacja
    przejazdzka_jutrznia <- gets (\(_, _, var, _) -> getWartoscNaMiejscu var 29)
    przejazdzka_fantazja <- gets (\(_, _, var, _) -> getWartoscNaMiejscu var 30)
    przejazdzka_zefir <- gets (\(_, _, var, _) -> getWartoscNaMiejscu var 31)
    przejazdzka_heros <- gets (\(_, _, var, _) -> getWartoscNaMiejscu var 32)
    if nazwaMiejsca obecnaLokalizacja == "konie"
        then do
            if przejazdzka_jutrznia && przejazdzka_fantazja && przejazdzka_zefir && przejazdzka_heros
                then do
                    case (imieKonia) of
                        ("fantazja") -> do
                            liftIO $ putStrLn "Jedyny słuszny wybór!"
                            liftIO $ putStrLn "Zakończyłeś zadanie związane z wyborem konia."
                            liftIO $ putStrLn "Możesz opuścić stajnie"
                            zmienStan 6 True
                        _ -> do
                            liftIO $ putStrLn "Nie powiem Ci, który koń jest najszybszy..."
                            liftIO $ putStrLn "Powiem Ci tylko, że to na pewno nie ten"
            else do
                liftIO $ putStrLn "Musisz przejechać się na wszystkich koniach, aby móc wybrać najszybszego"
    else do
        liftIO $ putStrLn "Tej komendy możesz użyć tylko w lokalizacji \'konie\'"

idz::String -> Game()
idz miejsce = do
    obecnaLokalizacja <- getObecnaLokalizacja
    obecneLokalizacje <- getListaLokalizacji
    mam_klucze <- gets (\(_, _, var, _) -> getWartoscNaMiejscu var 4)
    pokazanie_listu_krolowi <- gets (\(_, _, var, _) -> getWartoscNaMiejscu var 1)
    miecz <- gets (\(_, _, var, _) -> getWartoscNaMiejscu var 11)
    zbroja <- gets (\(_, _, var, _) -> getWartoscNaMiejscu var 12)
    kon <- gets (\(_, _, var, _) -> getWartoscNaMiejscu var 6)
    if miejsce `elem` polaczenia obecnaLokalizacja
        then do
            if not mam_klucze && miejsce == "konie"
                then do
                    liftIO $ putStrLn "Nie masz kluczy do tego pokoju, zdobadz je u masztalerza"
            else if not pokazanie_listu_krolowi && miejsce == "przedzamcze"
                then do
                    liftIO $ putStrLn "Nie możesz wyjść na przedzamcze, dopóki nie ukończysz wszystkich akcji na dworze zamkowym"
            else if not (miecz && zbroja && kon) && miejsce == "droga_do_wroga"
                then do
                    liftIO $ putStrLn "Nie jesteś jeszcze gotowy na podróż do wroga."
                    liftIO $ putStrLn "Potrzebujesz się uzbroić i zdobyć konia.\n"
            else do
                    let nowaLokalizacja = getLokalizacjaPoNazwie miejsce obecneLokalizacje
                    zmienLokalizacje (const nowaLokalizacja)
                    opis nowaLokalizacja

    else liftIO $ putStrLn "Nie można tam pójść."

-- print strings from list in separate lines
printLines :: [String] -> IO ()
printLines xs = putStr (unlines xs)

printWprowadzenie = printLines wprowadzenie
printInstrukcje = printLines tekstInstrukcji


getObecnaLokalizacja :: Game Lokalizacja
getObecnaLokalizacja = gets (\(location, _, _,_) -> location)

getListaLokalizacji :: Game Lokalizacje
getListaLokalizacji = gets (\(_, _, _,locations) -> locations)

getLokalizacjaPoNazwie :: String -> Lokalizacje -> Lokalizacja
getLokalizacjaPoNazwie name locations = case find (\loc -> nazwaMiejsca loc == name) locations of
  Just location -> location
  Nothing -> error "Nieznana lokalizacja."

zmienLokalizacje :: (Lokalizacja -> Lokalizacja) -> Game ()
zmienLokalizacje f = do
   modify (\(loc, inv,var,locs) -> (f loc, inv,var,locs))

getObiektyWLokalizacji :: Lokalizacja -> Game [String]
getObiektyWLokalizacji loc = do
  let items = przedmioty loc
  return items

getSciezkiZLok :: Lokalizacja -> Game [String]
getSciezkiZLok loc = do
  let sciezki = polaczenia loc
  return sciezki

getEkwipunek :: Game Ekwipunek
getEkwipunek = gets (\(_, ekwipunek, _,_) -> ekwipunek)

aktualizujEkwipunek :: (Ekwipunek -> Ekwipunek) -> Game ()
aktualizujEkwipunek f = modify (\(loc, inv,var,locs) -> (loc, f inv,var,locs))

czyPosiadanyPrzedmiot :: String -> Game Bool
czyPosiadanyPrzedmiot przedmiot = do
  aktualnyEkwipunek <- getEkwipunek
  return $ przedmiot `elem` aktualnyEkwipunek

podniesPrzedmiot :: String -> Game ()
podniesPrzedmiot przedmiot = do
    posiadany <- czyPosiadanyPrzedmiot przedmiot
    if posiadany
        then liftIO $ putStrLn "Posiadasz już ten przedmiot."
    else do
        lokalizacja <- getObecnaLokalizacja
        if przedmiot `elem` przedmioty lokalizacja
            then do
                if (przedmiot == "zlota_moneta")
                    then do
                        liftIO $ putStrLn "Kowal bacznie pilnuje, co robisz przy jego szafce."
                        liftIO $ putStrLn "Aby podebrać jego złotą monetę, musisz wykazać się ogromnym"
                        liftIO $ putStrLn "sprytem i odrobiną szczęścia."
                        liftIO $ putStrLn "Wpisz \'zagraj\', aby podjąć próbę."
                else do
                    aktualizujEkwipunek (przedmiot :)
                    zmienLokalizacje (\loc -> loc { przedmioty = filter (/= przedmiot) (przedmioty loc) })
                    if przedmiot == "list" then do
                        zmienStan 0 True
                        liftIO $ putStrLn "Podniesiono list"
                    else if przedmiot == "marchewki" then do
                        zmienStan 2 True
                        liftIO $ putStrLn "Podniesiono marchewki"
                    else if przedmiot == "cukier" then do
                        zmienStan 3 True
                        liftIO $ putStrLn "Podniesiono cukier"
                    else if przedmiot == "woda" then do
                        zmienStan 8 True
                        liftIO $ putStrLn "Podniesiono wodę"
                    else
                        liftIO $ putStrLn ("Podniesiono " ++ przedmiot)
        else
            liftIO $ putStrLn ("Nie ma tu takiego przedmiotu.")

zagraj :: Game()
zagraj = do
    lokalizacja <- getObecnaLokalizacja
    if (nazwaMiejsca lokalizacja == "szafka")
        then do
            liftIO $ putStrLn "Gdy naciśniesz enter, gra się rozpocznie."
            liftIO $ putStrLn "W losowym momencie na ekranie pojawi się napis STOP!."
            liftIO $ putStrLn "Musisz wówczas jak najszybciej kliknąć enter."
            liftIO $ putStrLn "Jeśli twój czas reakcji będzie poniżej 0.4 sekundy,"
            liftIO $ putStrLn "uda ci się podnieść złotą monetę. Powodzenia!\n"
            _ <- liftIO getLine
            liftIO $ putStrLn "START"
            delay <- liftIO $ randomRIO (2500000, 7000000)
            liftIO $ threadDelay delay
            liftIO $ putStrLn "STOP!"
            startTime <- liftIO $ getPOSIXTime
            liftIO getLine
            endTime <- liftIO $ getPOSIXTime
            wynik <- obliczCzasReakcji endTime startTime
            liftIO $ putStrLn ("Twój wynik to: " ++ show wynik)
            if (wynik > 0.05 && wynik < 0.4)
                then do
                    liftIO $ putStrLn "Gratulacje, udało ci się!\n"
                    aktualizujEkwipunek ("zlota_moneta" :)
                    zmienLokalizacje (\loc -> loc { przedmioty = filter (/= "zlota_moneta") (przedmioty loc) })
            else do
                liftIO $ putStrLn "Porażka, może uda się następnym razem!\n"
                zagraj
    else if (nazwaMiejsca lokalizacja == "droga_do_wroga")
        then do
            liftIO $ putStrLn "Aby pokonać bandziorów, potrzebne są szybkie i zwinne ruchy."
            liftIO $ putStrLn "Kliknij enter, a następnie w ciągu maksymalnie 10 sekund klikaj na zmianę \'a\' i \'d\' najszybciej jak potrafisz."
            liftIO $ putStrLn "Przed upływem 10 sekund musisz zatwierdzić swój rezultat klikając enter."
            liftIO $ putStrLn "Potrzebujesz minimum 70 kliknięć, aby wygrać walkę. Powodzenia!"
            _ <- liftIO getLine            
            liftIO $ putStrLn "START!"
            startTime <- liftIO $ getPOSIXTime            
            wynik <- liftIO getLine
            endTime <- liftIO $ getPOSIXTime
            czas <- obliczCzasReakcji endTime startTime
            liftIO $ putStrLn ("Twój czas to: " ++ show czas)
            liftIO $ putStrLn ("Liczba klikniec: " ++ show (length wynik))
            if (czas < 10 && length wynik > 69)
                then do
                    liftIO $ putStrLn "Gratulacje, udało ci się!"
                    liftIO $ putStrLn "Pokonałeś wszystkich bandziorów, nie będą więcej ci przeszkadzać."
                    liftIO $ putStrLn "Możesz kontynuować swoją podróż do zamku wroga."
                    -- zakonczone bandziory na True
                    zmienStan 13 True
            else do
                liftIO $ putStrLn "Porażka, spróbuj ponownie!\n"
                zagraj
    else do
        liftIO $ putStrLn "W tym miejscu nie ma żadnej gry."

obliczCzasReakcji :: POSIXTime -> POSIXTime -> StateT (Lokalizacja, Ekwipunek, StanGry, Lokalizacje) IO Double
obliczCzasReakcji startTime endTime = do
  let wynik = startTime - endTime
  return (realToFrac wynik)

rozmawiaj :: Game ()
rozmawiaj = do
    lokalizacja <- getObecnaLokalizacja
    if (nazwaMiejsca lokalizacja == "kowal")
        then do
            liftIO $ putStrLn "Podchodzisz do zapracowanego kowala, który w końcu cię zauważa."
            liftIO $ putStrLn "Kowal: Nie widzisz, że jestem zajęty?"
            liftIO $ putStrLn "Kowal: Jeśli czegoś ode mnie chcesz, to nie da rady."
            liftIO $ putStrLn "Kowal: No chyba, że pomożesz mi z kilkoma rzeczami..."
            liftIO $ putStrLn "Rycerz: Potrzebuję dostać miecz i zbroję."
            liftIO $ putStrLn "Kowal: To nie są tanie rzeczy, ale myślę, że się dogadamy."
            liftIO $ putStrLn "Rycerz: Słucham."
            liftIO $ putStrLn "Kowal: Jak widzisz, właśnie pracuję nad jednym mieczem."
            liftIO $ putStrLn "Kowal: Tak się składa, że zgubiłem gdzieś tutaj do niego rękojeść."
            liftIO $ putStrLn "Kowal: Jeśli ją znajdziesz, oddam ci mój stary, lecz wciąż sprawny miecz."
    else do
        liftIO $ putStrLn "Nie masz z kim porozmawiac."

rozwiazanie :: String -> Game ()
rozwiazanie haslo = do
    if (haslo == "ZAMÓWIENIE")
        then do
            liftIO $ putStrLn "Rycerz: Przetłumaczyłem otrzymaną wiadomość, wszystko spisałem na dole pisma."
            liftIO $ putStrLn "Rycerz: Chodzi o jakieś zamówienie."
            liftIO $ putStrLn "Kowal: Ach, no tak, tak!"
            liftIO $ putStrLn "Kowal: Dziękuję za twój wysiłek. Jendak zanim dam ci zbroję, "
            liftIO $ putStrLn "       musisz mi jeszcze obiecać, że nikomu nie powiesz o treści tego pisma..."
            liftIO $ putStrLn "       To dla mnie bardzo ważne."
            liftIO $ putStrLn "Rycerz: Obiecuję. Słowo rycerza."
            liftIO $ putStrLn "Kowal: Wspaniale. Jeszcze raz dziękuję ci za wszystko. Oto twoja zbroja.\n"
            liftIO $ putStrLn "** nowy przedmiot w ekwipunku: zbroja **\n"
            -- dodaj zbroje
            aktualizujEkwipunek ("zbroja" :)
            liftIO $ putStrLn "Rycerz: Dziękuję kowalu, interesy z tobą to przyjemność."
            -- ustaw otrzymano zbroje na True
            zmienStan 12 True
    else do
        liftIO $ putStrLn "Niepoprawne rozwiązanie, spróbuj ponownie."


wykonajPolecenie :: String -> Game ()
wykonajPolecenie polecenie = case words polecenie of
    ["instrukcje"] -> liftIO printInstrukcje
    ["eq"] -> do
        ekwipunek <- getEkwipunek
        liftIO $ putStrLn ("Twój ekwipunek: " ++ show ekwipunek)
    ["spojrz"] -> do
        obecnaLokalizacja <- getObecnaLokalizacja
        opis obecnaLokalizacja
    ["wspinaczka"] -> wspinaczka
    ["walcz"] -> walcz
    ["idz", miejsce] -> do
        idz miejsce
    ["zagraj"] -> zagraj
    ["rozmawiaj"] -> rozmawiaj
    ["rozwiazanie", haslo] -> rozwiazanie haslo
    ["obudz"] -> obudz
    ["oblej"] -> oblej
    ["nakarm", imieKonia, nazwaPrzedmiotu] -> do
        nakarm imieKonia nazwaPrzedmiotu
    ["jedz", imieKonia] -> do
        jedz imieKonia
    ["wybierz", imieKonia] -> do
        wybierz imieKonia
    ["podnies", przedmiot] -> do
        if przedmiot == "klucz" then do
            podniesKlucz "klucz"
        else do podniesPrzedmiot przedmiot
    _ -> liftIO $ putStrLn "Nieznane polecenie."


-- note that the game loop may take the game state as
-- an argument, eg. gameLoop :: State -> IO ()
petlaGry :: Game ()
petlaGry = do
    loc <- getObecnaLokalizacja
    inv <- getEkwipunek

    liftIO $ do

        putStrLn "\nTwoje polecenia:"
    polecenie <- liftIO getLine
    wykonajPolecenie polecenie
    petlaGry

main = do
    printWprowadzenie
    printInstrukcje
    runStateT petlaGry (sypialniaKsiecia, [], stan, listaLokalizacji)
