/* Gra Uratuj Księżniczkę, by Hubert Brzóskniewicz, Paweł Rogóż, Filip Browarny. */

:- dynamic lokalizacja/1, w/2, trzymane/1, zakończone/1, połączenie/2, oswojony/1, sprawdzony/1.
:- retractall(w(_, _)), retractall(lokalizacja(_)), retractall(alive(_)), retractall(trzymane(_)), 
        retractall(zakończone(_)), retractall(połączenie(_,_)), retractall(oswojony(_)), retractall(sprawdzony(_)).

lokalizacja(sypialnia_ksiecia).


/* Wyświetlenie ekwipunku. */

eq :-
        trzymane(X),
        write("Posiadasz następujące przedmioty: "),
        nl,
        ekwipunek,
        !.

eq :-
        write("Nie posiadasz żadnego przedmiotu."),
        nl.

ekwipunek :- 
        trzymane(X),
        write('- '),
        write(X),
        nl,
        fail.

ekwipunek.

/* Opisy podnoszenia przedmiotów. */

podnieś(list) :-
        lokalizacja(pralnia),
        w(list, pralnia),
        retract(w(list, pralnia)),
        assert(trzymane(list)),
        write('Wziąłeś list'), nl,
        write('Aby przeczytać jego zawartość, wpisz komendę: przeczytaj(list)'), nl, !.

podnieś(złota_moneta) :-
        lokalizacja(szafka),
        w(złota_moneta, szafka),
        write('Kowal bacznie pilnuje, co robisz przy jego szafce.'), nl,
        write('Aby podebrać jego złotą monetę, musisz wykazać się ogromnym'), nl,
        write('sprytem i odrobiną szczęścia.'), nl,
        write('Wpisz \'zagraj.\', aby podjąć próbę.'), nl, !.

podnieś(X) :-
        trzymane(X),
        write('Masz już to w ekwipunku!'),
        !, nl.

podnieś(X) :-
        lokalizacja(Place),
        w(X, Place),
        retract(w(X, Place)),
        assert(trzymane(X)),
        write('OK.'),
        !, nl.

podnieś(_) :-
        write('Nie widzę tego tutaj!.'),
        nl.


/* Predykaty wyrzucania przedmiotów. */

wyrzucono(X) :-
        trzymane(X),
        lokalizacja(Place),
        retract(trzymane(X)),
        assert(w(X, Place)), !.

wyrzucono(_) :-
        write('Nie masz takiego przedmiotu!'),
        nl.

wyrzuć(X) :-
        trzymane(X),
        lokalizacja(Place),
        retract(trzymane(X)),
        assert(w(X, Place)),
        write('OK.'),
        !, nl.

wyrzuć(_) :-
        write('Nie masz takiego przedmiotu!'),
        nl.

/* Predykaty poruszania się. */

idź(przedzamcze) :-
        not(zakończone(pokazanie_listu_królowi)),
        lokalizacja(brama_zamkowa),
        write('Nie możesz jeszcze tam iść!'), nl,
        write('W tym momencie Twoim zadaniem jest pokazanie listu królowi.'), nl,
        write('Zrób to jak najszybciej!'), nl, nl,
        możliwe_przejścia(brama_zamkowa), !.

idź(droga_do_wroga) :-
        (not(trzymane(zbroja));
        not(trzymane(stary_miecz));
        not(trzymane(fantazja))),
        write('Nie jesteś jeszcze gotowy na podróż do wroga.'), nl,
        write('Potrzebujesz się uzbroić i zdobyć konia.'), nl, nl, !, spójrz.

idź(Dokąd) :-
        lokalizacja(Skąd),
        (połączenie(Skąd, Dokąd) ; połączenie(Dokąd, Skąd)),
        retract(lokalizacja(Skąd)),
        assert(lokalizacja(Dokąd)),
        !, spójrz.

idź(_) :-
        write('Takie przejście nie istnieje').



spójrz :-
        lokalizacja(Place),
        opis(Place),
        nl,
        możliwe_przejścia(Place),
        nl,
        notice_beginning(Place),
        notice_objects_at(Place),
        nl.

/* Predykaty wypisujące obiekty w pomieszczeniu. */

notice_beginning(Place) :-
        w(X, Place),
        write('Przedmioty w tym miejscu: '), nl, !.

notice_beginning(_).

notice_objects_at(Place) :-
        w(X, Place),
        write('-> '), write(X), nl,
        fail.

notice_objects_at(_).

/* Koniec gry i instrukcje. */

die :-
        finish.

finish :-
        nl,
        write('Koniec gry. Wprowadź komendę "halt.", aby zakończyć.'),
        nl.



instrukcje :-
        nl,
        write('Wprowadzaj komendy używając standardowej składni Prologu.'), nl,
        write('Dostępne komendy'), nl,
        write('start.               -- rozpocznij grę.'), nl,
        write('idź(miejsce).        -- aby przejść w dane miejsce.'), nl,
        write('eq.                  -- aby pokazać ekwipunek.'), nl,
        write('podnieś(przedmiot).  -- aby podnieść przedmiot.'), nl,
        write('wyrzuć(przedmiot).   -- aby wyrzucić przedmiot.'), nl,
        write('spójrz.              -- aby rozejrzeć się dookoła.'), nl,
        write('instrukcje.          -- aby zobaczyć tą wiadomość ponownie.'), nl,
        write('halt.                -- aby zakończyć grę i wyjść.'), nl,
        nl.

start :-
        instrukcje,
        spójrz.

/*Sciezki:*/

połączenie(sypialnia_ksiecia, korytarz).
połączenie(kuchnia, korytarz).
połączenie(zbrojownia, korytarz).
połączenie(pralnia, korytarz).
połączenie(komnata_krola, korytarz).
połączenie(brama_zamkowa, korytarz).
połączenie(brama_zamkowa, przedzamcze).
połączenie(kowal, przedzamcze).
połączenie(kowal, lada).
połączenie(kowal, składzik).
połączenie(kowal, kowadło).
połączenie(kowal, regały).
połączenie(kowal, szafka).
połączenie(lada, składzik).
połączenie(składzik, kowadło).
połączenie(kowadło, regały).
połączenie(regały, szafka).
połączenie(szafka, lada).
połączenie(stajnia, przedzamcze).
połączenie(droga_do_wroga, przedzamcze).
połączenie(droga_do_wroga, brama_wroga).
połączenie(droga_do_wroga, mury_zamku_wroga).
połączenie(mury_zamku_wroga, brama_wroga).
połączenie(wartownia, korytarz_wroga).
połączenie(wieza_zamkowa, korytarz_wroga).
połączenie(lochy, korytarz_wroga).
połączenie(wieza_zamkowa, drzwi).

połączenie(stajnia, pokoj).
połączenie(stajnia, wybieg).
połączenie(stajnia, spichlerz).

możliwe_przejścia(Miejsce) :-
        write('Z tego miejsca możesz przejść do: '),
        nl,
        przejścia(Miejsce).

przejścia(Skąd) :-
        (połączenie(Skąd, Dokąd) ; połączenie(Dokąd, Skąd)),
        write('-> '),
        write(Dokąd),
        nl,
        fail.

przejścia(_).

/* Opisy pomieszczeń:*/

opis(kowal) :- 
        \+ trzymane(rękojeść),
        \+ zakończone(kowal_ekwipunek),
        \+ zakończone(kowal_miecz),
        write('Jesteś u kowala.'), nl,
        write('Zauważasz, że właśnie ciężko pracuje on nad tworzeniem nowego miecza.'), nl,
        write('Może będziesz w stanie uzyskać tutaj potrzebny ekwipunek...'), nl, nl,
        write('-- aby zacząć rozmowę z kowalem, wpisz \'rozmawiaj.\' --'), !, nl.

opis(kowal) :-
        trzymane(rękojeść),
        write('Rycerz: Znalazłem rękojeść, której szukałeś.'), nl,
        retract(trzymane(rękojeść)),
        write('Kowal: Znakomicie! Wiedziałem, że ci się uda.'), nl,
        write('Kowal: Widzisz, na startośc tak już jest. Zostawiasz gdzieś rzeczy, '), nl,
        write('       i później sam zapominasz gdzie to się podziało. Bardzo ci dziękuję.'), nl,
        write('Rycerz: Żaden problem.'), nl,
        write('Kowal: Tak jak obiecywałem, przekazuję ci mój stary miecz.'), nl, nl,
        write('** nowy przedmiot w ekwipunku: stary_miecz **'), nl, nl,
        assert(trzymane(stary_miecz)),
        write('Rycerz: Bardzo ci dziękuję, z pewnością będzie mi dobrze służył.'), nl,
        write('Rycerz: Mam do ciebie jeszcze jedną sprawę. Czy dostanę tutaj też nową zbroję?'), nl,
        write('Kowal: Oczywiście, mam gotowych kilka kompletów. Właściwie, to mam jeszcze jedną rzecz,'), nl,
        write('       z którą nie jestem w stanie sobie poradzić. Dotarło do mnie pismo, lecz nic'), nl,
        write('       z niego nie rozumiem. Wygląda to na zlepek losowych znaków. Może ty coś'), nl,
        write('       z tego odczytasz...'), nl, nl,
        write('----------------------------------------------------------------------------------'), nl,
        write('ŚCIŚLE TAJNE'), nl,
        write('-.. .-. --- --. .. / -.- --- .-- .- .-.. ..- .-.-.- /
... -.- .-..- .- -.. .- -- / -.- --- .-.. . .--- -. . / -....- --.. .- -- ---. .-- .. . -. .. . -....- .-.-.- /
- -.-- -- / .-. .- --.. . -- / .--. --- - .-. --.. . -... ..- .--- ..-.. / -.. .. .- -- . -. - --- .-- .-.- /
-- --- - -.-- -.- ..-.. / .. / --.. .-..- --- - -.-- / -- .. . -.-. --.. .-.-.- /
-.. --- --. .- -.. .- -- -.-- / ... .. ..-.. / .--- .- -.- / --.. .-- -.-- -.- .-.. . .-.-.- /
- .-- ---. .--- / --. .-.-.-'), nl,
        write('----------------------------------------------------------------------------------'), nl, nl,
        write('-- gdy uporasz się z zagadką, przebywając u kowala wpisz w terminal frazę \'rozwiązanie_SŁOWO KLUCZ.\' --'), !, nl,
        assert(zakończone(kowal_miecz)).

opis(kowal) :-
        zakończone(kowal_miecz),
        \+ zakończone(kowal_ekwipunek),
        write('----------------------------------------------------------------------------------'), nl,
        write('ŚCIŚLE TAJNE'), nl,
        write('-.. .-. --- --. .. / -.- --- .-- .- .-.. ..- .-.-.- /
... -.- .-..- .- -.. .- -- / -.- --- .-.. . .--- -. . / -....- --.. .- -- ---. .-- .. . -. .. . -....- .-.-.- /
- -.-- -- / .-. .- --.. . -- / .--. --- - .-. --.. . -... ..- .--- ..-.. / -.. .. .- -- . -. - --- .-- .-.- /
-- --- - -.-- -.- ..-.. / .. / --.. .-..- --- - -.-- / -- .. . -.-. --.. .-.-.- /
-.. --- --. .- -.. .- -- -.-- / ... .. ..-.. / .--- .- -.- / --.. .-- -.-- -.- .-.. . .-.-.- /
- .-- ---. .--- / --. .-.-.-'), nl,
        write('----------------------------------------------------------------------------------'), nl, nl,
        write('-- gdy uporasz się z zagadką, przebywając u kowala wpisz w terminal frazę \'rozwiązanie_SŁOWO KLUCZ.\' --'), !, nl.

opis(kowal) :-
        zakończone(kowal_ekwipunek),
        write('Jesteś u kowala.'), !, nl.

opis(składzik) :-
        write('Jesteś w składziku.'), nl,
        write('Jest tu spory bałagan, lecz zauważasz na wierzchu kilka rzeczy.'), !, nl.

opis(lada) :-
        write('Spoglądasz pod ladę, lecz nie zauważasz tu nic ciekawego.'), !, nl.
        
opis(regały) :-
        \+ zakończone(rękojeść),
        trzymane(drabina),
        write('Podchodzisz do regałów.'), nl,
        write('Zauważasz rękojeść na najwyższej półce.'), nl,
        write('Aby jej dosięgnąć, wykorzystujesz wcześniej podniesioną drabinę.'), nl,
        write('Stawiasz drabinę obok regału.'), nl,
        write('Po wejściu na nią udaje ci się sięgnąć rękojeść.'), nl,
        wyrzucono(drabina),
        assert(trzymane(rękojeść)),
        assert(zakończone(rękojeść)), !.

opis(regały) :-
        zakończone(rękojeść),
        write('Podchodzisz do regałów.'), nl,
        write('Nie ma tutaj już nic interesującego.'), !, nl.

opis(regały) :-
        write('Podchodzisz do regałów.'), nl,
        write('Rozglądasz się. Po chwili zauważasz rękojeść.'), nl,
        write('Próbujesz po nią sięgnąć, lecz jest ona dla ciebie za wysoko.'), nl, nl,
        write('Rycerz: Potrzebuję na coś wejść, aby ją sięgnąć...'), !, nl.

opis(kowadło) :-
        write('Sprawdzasz okolicę obok kowadła.'), nl,
        write('Leży tu kilka sprzętów, lecz nie dostrzegasz nic przydatnego.'), !, nl.

opis(szafka) :-
        write('Podchodzisz do szafki w rogu pomieszczenia.'), nl,
        write('Otwierasz drzwiczki. W środku znajdujesz kilka rzeczy.'), !, nl.

opis(sypialnia_ksiecia) :-
        zakończone(wybudzenie),
        write('Jesteś w sypialni księcia'), nl,
        write('W tym pokoju nie znajduje się nic przydatnego'), nl,
        write('Wyjdź na korytarz i rozejrzyj się po zamku'), nl, !.

opis(sypialnia_ksiecia) :-
        assert(zakończone(wybudzenie)),
        write('Kolejny beztroski dzień w grodzie zamku'), nl,
        write('Przewracasz się z boku na bok, zastanawiasz się, czy może powinieneś już wstać z łóżka'), nl,
        write('Nagle słyszysz głośny huk drzwi'), nl,
        write('Do pokoju wbiega jeden z pracowników dworu'), nl,
        write('Pracownik: Książe! Wstawaj! Wstawaj!'), nl,
        write('Ty: Co się stało?'), nl,
        write('P: Porwano księżniczkę!'), nl,
        write('T: Co? Jak to?'), nl,
        write('P: Nie wiem, na dworze jest straszne zamieszanie. Król kazał Cię jak najszybciej wezwać'), nl,
        write('Wyjdź na korytarz, używając komendy: idź(korytarz) i spróbuj znaleźć króla'), nl, !.

opis(komnata_krola) :-
        not(trzymane(list)),
        write('Otwierasz drzwi do komnaty króla'), nl,
        write('Słyszysz dobiegający z wnętrza dźwięk szlochania'), nl,
        write('Wchodzisz do środka i widzisz króla, który zapłakany siedzi na tronie'), nl,
        write('Ty: Królu! Co się stało?'), nl,
        write('Król: Porwano moją córkę!'), nl,
        write('T: Co? Jak to?'), nl,
        write('K: Nie wiem, jak to się stało. Wszystko działo się tak szybko.'), nl,
        write('   Wszystko, co wiem, to to, że w komnacie znalazłem list'), nl,
        write('   Jest w rogu pokoju, weź go i przeczytaj'), nl,
        write('   Zrób wszystko, co w Twojej mocy, aby ją odnaleźć'), nl,
        write('T: Nie widzę tutaj żadnego listu'), nl,
        write('K: O nie! Była tu rano sprzątaczka, pewnie go wzięła.'), nl,
        write('   Musisz ją znaleźć. Na pewno jest gdzieś w zamku'), nl, !.

opis(komnata_krola) :-
        zakończone(pokazanie_listu_królowi),
        write('Król: Czego tu jeszcze szukasz?'), nl,
        write('Król: Znajdź moją córkę!'), nl, !.

opis(komnata_krola) :-
        trzymane(list),
        assert(zakończone(pokazanie_listu_królowi)),
        write('Król: I jak? Znalazłeś już list?'), nl,
        write('Ty: Tak, zobacz go proszę'), nl,
        write('*pokazujesz list królowi*'), nl,
        write('K: MK? To nie może być...'), nl,
        write('T: Kto to jest?'), nl,
        write('K: To mój brat. Zawsze był zazdrosny o potęgę mojego królestwa.'), nl,
        write('T: Czego on chce?'), nl,
        write('K: Nie wiem, ale musisz go powstrzymać. Nie pozwolę, aby zrobił krzywdę mojej córce.'), nl,
        write('   Jego zamek znajduje się na północy. Potrzebujesz konia, żeby tam dotrzeć.'), nl,
        write('   Nasze grody od dawna za sobą nie przepadają. Nie będzie to łatwe zadanie'), nl,
        write('   Musisz się też uzbroić. Idź do kowala, znajdziesz go w przedzamczu.'), nl,
        write('T: Oczywiście. Królu, obiecuję, że przyprowadzę księżniczkę z powrotem.'), nl, !.

opis(korytarz) :-
        write('Znajdujesz się w korytarzu Twojego zamku'), nl,
        write('Pamiętaj, aby zajrzeć do każdego pokoju w zamku'), nl,
        write('Mogą się w nich znajdować cenne wskazówki i przedmioty,'), nl,
        write('które mogą okazać się niezbędne do wykonania Twoich zadań'), nl, !.

opis(kuchnia) :-
        (w(marchewki, kuchnia); w(cukier, kuchnia)),
        write('Kucharka: Co się dzieje w zamku? Czy już wiesz, co się stało?'), nl,
        write('Ty: Pracuję nad tym.'), nl,
        write('W rogu pokoju znajduje się sterta marchewek i cukier.'), nl,
        write('Mogą się przydać na później'), nl, !.

opis(kuchnia) :-
        write('Kucharka przygotowuje obiad'), nl,
        write('Kucharka: Po co tu znów przychodzisz?'), nl,
        write('Ty: Szukam wskazówek...'), nl,
        write('K: Czy ja wyglądam na kogoś, kto może Ci z tym pomóc?'), nl,
        write('   Nie zawracaj mi i sobie głowy. Wychodź!'), nl, !.

opis(zbrojownia) :-
        write('Pracownik zbrojowni: Co Ty tu jeszcze robisz? Znajdź księżniczkę, a nie szlajaj się po zamku!'), nl, !.

opis(pralnia) :-
        zakończone(znalezienie_listu),
        write('Służąca: Czego tu jeszcze szukasz?'), nl,
        write('S: Czas jest teraz bardziej niż cenny, musisz się spieszyć'), nl, !.

opis(pralnia) :-
        assert(zakończone(znalezienie_listu)),
        write('Służąca: Doszły do mnie wieści. Jak czuje się król?'), nl,
        write('Ty: Nie najlepiej. Sprzątałaś może dziś w jego pokoju?'), nl,
        write('S: Oczywiście, jak codziennie. Mnóstwo babilotów i papierów, miałam dziś dużo pracy'), nl,
        write('T: Gdzie są te papiery?'), nl,
        write('S: Właśnie miałam je spalić, są w rogu pokoju'), nl,
        write('T: Muszę się im przyjrzeć'), nl, !.

opis(brama_zamkowa) :-
        zakończone(pokazanie_listu_królowi),
        write('Znajdujesz się w bramie zamkowej'), nl,
        write('Za bramą znajduje się przedzamcze, z którego'), nl,
        write('możesz udać się do miejsc w okolicy zamku'), nl,
        write('Na pewno będzie interesować Cię zakład kowala'), nl,
        write('Zajrzyj też do stajni, aby wziąć konia'), nl, !.

opis(brama_zamkowa) :-
        write('W tym momencie gry nie wiesz, jaki jest Twój cel'), nl,
        write('Znajdź list i pokaż go królowi'), nl,
        write('Dopiero wtedy będziesz naprawdę gotowy do rozpoczęcia przygody'), nl, !.

/* Opisy pokojów w stajni */

opis(stajnia) :-
        zakończone(wybor_konia),
        write('W stajni nie ma już nic ciekawego'), nl,
        write('Wybrałeś konia, pora zająć się następnymi zadaniami'), nl,
        write('No już, opuszczaj pokój - czas jest cenny!'), nl, !.

opis(stajnia) :- 
        not(trzymane(klucze)),
        write('Otwierasz drzwi stajni'), nl,
        write('Rozglądasz się dookoła i nie widzisz nikogo.'), nl,
        write('Drzwi do pokoju, w którym znajdują się konie, są zamknięte'), nl,
        write('Udaj się do pokoju masztalerza, on pomoże Ci je otworzyć'), nl, !.

opis(stajnia) :-
        trzymane(klucze),
        write('Masz klucze, to wspaniale!'), nl,
        write('Otwórz drzwi do pokoju z końmi, wpisując komendę: \'otwórz.\''), nl,
        write('Po otworzeniu drzwi pojawi się nowa ścieżka, która umożliwi Ci wejście do pokoju'), nl,
        write('Zauważysz ją, wpisując komendę \'spójrz.\', po otworzeniu drzwi'), nl, !.

opis(pokoj) :-
        zakończone(wybudzenie_masztalerza),
        write('Masztalerz śpi'), nl,
        write('Nie będziemy go wybudzać, to za ciężkie...'), nl,
        write('Wróć do stajni'), !.

opis(pokoj) :-
        write('Wchodzisz do pokoju masztalerza. Co on robi?'), nl,
        write('Oczywiście - śpi. Jak zwykle...'), nl,
        write('Ty: Wstawaj! Pobudka! Potrzebuję Cię!'), nl,
        write('Ani drgnie. Jest znany w całym grodzie ze swojego głębokiego snu'), nl,
        write('Aby spróbować go obudzić, użyj komendy \'obudź(masztalerz)\''), nl, !.

opis(konie) :-
        zakończone(wybor_konia),
        write('Masz już konia, możesz więc opuścić teren stajni'), nl,
        write('Nie znajdziesz tu już nic więcej'), nl, !.

opis(konie) :-
        zakończone(oswajanie),
        wyrzucono(marchewki),
        wyrzucono(cukier),
        write('Musisz teraz wybrać najszybszego konia'), nl,
        write('No dalej, nie ma czasu do stracenia!'), nl, !.

opis(konie) :-
        write('Znajdujesz się teraz w pokoju konnym'), nl,
        write('Problem jest taki, że konie się Ciebie boją'), nl,
        write('Musisz je jakoś do siebie przekonać'), nl,
        write('Jedne konie lubią marchewkę, inne cukier'), nl,
        write('Musisz je nakarmić ich ulubionym pokarmem, aby chciały z Tobą współpracować'), nl,
        write('Aby nakarmić konia, użyj komendy \'nakarm(imię_konia,marchewki/cukier)\''), nl, 
        write('Jeśli nie masz tych pokarmów, musisz wrócić do zamkowej kuchni i je zdobyć'), nl, !.

opis(brama_wroga) :-
                        write('Dotarłeś do bramy wroga.'), nl,
                        write('Niestety bramy pilnuje wielu uzbrojonych żołnierzy,'), nl,
                        write('a na murach dostrzegasz łuczników.'), nl,
                        write('Przejście tędy nie wchodzi w grę, musisz znaleźć inną drogę.'), !, nl.

opis(mury_zamku_wroga) :- write('Dostrzegasz możliwość dostania się do środka.'), nl,
                        write('Żołnierzom patrolującym mury zajmuje około 10 minut zrobienie okrążenia.'), nl,
                        write('Jeśli wykażesz się odpowiednią zwinnością oraz szybkością,'), nl,
                        write('Powinno udać ci się wspiąć na mury nie zauważonym.'), nl, nl,
                        write('Aby przejść dalej musisz wykazać się dobrym wyczuciem czasu.'), nl,
                        write('Wpisz \'zagraj\' aby rozpocząć grę.'), !, nl.
       
opis(korytarz_wroga) :- write('Udało ci się dostać do środka zamku, w którym uwięziona jest księżniczka.'), nl,
                        write('Twoim kolejnym zadaniem jest znalezienie jej.'), !, nl.

opis(lochy) :- write('Schodzisz do lochów.'), nl,
                        write('Masz szczęście, żołnierz który pilnuje lochu śpi na warcie.'), nl,
                        write('Patrzysz kto znajduje się w celach, natomiast nigdzie nie ma księżniczki.'), nl,
                        write('Nawet tak zły król, jak władca tego zamku nie wtrąciłby księżniczki do lochów.'), !, nl.

opis(wartownia) :-
                        not(zakończone(wartownik_zabity)),
                        write('Po wejściu do wartowni dostrzegasz żołnierza z pękiem kluczy przy pasie.'), nl,
                        write('Niestety on także ciebie zauwarzył i zaczyna wyciągać swój miecz.'), nl,
                        write('Pokonaj go aby zdobyc klucze.'), nl,
                        write('Ta mini gra sprawdzi twoją zręczność, a także prędkość.'), nl,
                        write('Wpisz \'zagraj\', aby rozpocząć grę.'), !, nl.

opis(wartownia) :-  not(trzymane(klucz)),
                        write('Na ziemi leży martwy wartownik'), nl,
                        write('A przy jego pasie wisi przypięty pęk kluczy.'), nl,
                        write('Wpisz \'podnieś(klucz)\', aby je podnieść.'), !, nl.

opis(wartownia) :-  write('Na ziemi leży martwy wartownik'), nl,
                        write('Wykazałeś się dużymi umiejętnościami pokonując go.'), !, nl.

opis(drzwi) :- trzymane(klucz),
                        write('Próbujesz otworzyć drzwi kluczem zabranym wartownikowi,'), nl,
                        write('całe szczęście, klucz pasuje, udaje ci się otworzyć drzwi.'), nl,
                        write('Na łóżku w ciemnym pomieszczeniu dostrzegasz księżniczkę.'), nl,
                        write('Gratulacje wygrałeś!'), !, nl, nl, nl,
                        write('         .* *.               `o`o`'), nl,
                        write('         *. .*              o`o`o`o      ^,^,^'), nl,
                        write('           * \\               `o`o`     ^,^,^,^,^'), nl,
                        write('              \\     ***        |       ^,^,^,^,^'), nl,
                        write('               \\   *****       |        /^,^,^'), nl,
                        write('                \\   ***        |       /'), nl,
                        write('    ~@~*~@~      \\   \\         |      /'), nl,
                        write('  ~*~@~*~@~*~     \\   \\        |     /'), nl,
                        write('  ~*~@smd@~*~      \\   \\       |    /     #$#$#        .`\'.;.'), nl,
                        write('  ~*~@~*~@~*~       \\   \\      |   /     #$#$#$#   00  .`,.\','), nl,
                        write('    ~@~*~@~ \\        \\   \\     |  /      /#$#$#   /|||  `.,\''), nl,
                        write('_____________\\________\\___\\____|_/______/_________|\\/\\___||______'), nl,
                        finish.

opis(drzwi) :-
                        write('Próbujesz otworzyć drzwi, niestety są zamknięte.'), nl,
                        write('Musisz znaleźć klucz.'), !, nl.

opis(wieza_zamkowa) :-
                        write('Po długiej wspinaczce docierasz na szczyt wieży zamkowej.'), nl,
                        write('Dostrzegasz drzwi.'), !, nl.


opis(droga_do_wroga) :-
        zakończone(bandziory),
        write('Jesteś w drodze do wroga.'), nl, !.

opis(droga_do_wroga) :-
        write('Jesteś w drodze do wroga.'), nl,
        write('Jedziesz spokojnie na koniu, aż nagle zauważasz w oddali 3 osoby.'), nl,
        write('Blokują ci drogę, jesteś zmuszomny do konfrontacji.'), nl, nl,
        write('Bandzior1: Hola hola, dokąd to.'), nl,
        write('Bandzior2: Myślałeś, że przejedziesz sobie tędy bezproblemowo?'), nl,
        write('           Grubo się myliłeś.'), nl,
        write('Bandzior3: Tylko nie próbuj żadnych sztuczek!'), nl, nl,
        write('-- Bandzior3 wyciąga włócznię --'), nl, nl,
        write('Rycerz: Witajcie panowie, nie szukam żadnych problemów!'), nl,
        write('        Na pewno jakoś się dogadamy.'), nl,
        write('Bandzior1: Wyskakuj lepiej ze swoich kosztowności.'), nl, nl,
        write('-- Bandzior z włócznią zbliża się do ciebie --'), nl, nl,
        czy_posiada_monete, !.


opis(X) :- write('Jesteś w: '), write(X), nl.


czy_posiada_monete :-
        trzymane(złota_moneta),
        write('Rycerz: Spokojnie, spokojnie!'), nl, nl,
        write('Z wartościowych rzeczy posiadasz jedynie złotą monetę,'), nl,
        write('być może uda ci się przy jej pomocy wydostać z tarapatów...'), nl, nl,
        write('Czy chcesz oddać bandziorom złotą monetę? (t./n.)'), nl,
        read(X), nl,
        ((X == n) -> fail ; write('Rycerz: Proszę, oto wszystko co mam.'), nl, nl,
        write('-- podaje złotą monetę --'), nl, nl,
        retract(trzymane(złota_moneta)),
        write('Bandzior1: No proszę, czyli faktycznie dało się dogadać.'), nl,
        write('           A teraz zjeżdzaj stąd i nie pojawiaj się tu więcej!'), nl, 
        assert(zakończone(bandziory)), !).

czy_posiada_monete :-
        write('Rycerz: Po moim trupie, niczego wam nie oddam!'), nl, nl,
        write('-- wyciągasz miecz i rozpoczynasz walkę z bandziorami --'), nl, nl,
        zagraj.


/* Dialogi: */

rozmawiaj :-
        lokalizacja(kowal),
        write('Podchodzisz do zapracowanego kowala, który w końcu cię zauważa.'), nl,
        write('Kowal: Nie widzisz, że jestem zajęty?'), nl,
        write('Kowal: Jeśli czegoś ode mnie chcesz, to nie da rady.'), nl,
        write('Kowal: No chyba, że pomożesz mi z kilkoma rzeczami...'), nl,
        write('Rycerz: Potrzebuję dostać miecz i zbroję.'), nl,
        write('Kowal: To nie są tanie rzeczy, ale myślę, że się dogadamy.'), nl,
        write('Rycerz: Słucham.'), nl,
        write('Kowal: Jak widzisz, właśnie pracuję nad jednym mieczem.'), nl,
        write('Kowal: Tak się składa, że zgubiłem gdzieś tutaj do niego rękojeść.'), nl,
        write('Kowal: Jeśli ją znajdziesz, oddam ci mój stary, lecz wciąż sprawny miecz.'), !, nl.

rozmawiaj :-
        write('Nie masz z kim porozmawiać.'), nl.

/* koniec wątku u kowala: */

rozwiązanie_ZAMÓWIENIE :-
        lokalizacja(kowal),
        write('Rycerz: Przetłumaczyłem otrzymaną wiadomość, wszystko spisałem na dole pisma.'), nl,
        write('Rycerz: Chodzi o jakieś zamówienie.'), nl,
        write('Kowal: Ach, no tak, tak!'), nl,
        write('Kowal: Dziękuję za twój wysiłek. Jendak zanim dam ci zbroję, '), nl,
        write('       musisz mi jeszcze obiecać, że nikomu nie powiesz o treści tego pisma...'), nl,
        write('       To dla mnie bardzo ważne.'), nl,
        write('Rycerz: Obiecuję. Słowo rycerza.'), nl,
        write('Kowal: Wspaniale. Jeszcze raz dziękuję ci za wszystko. Oto twoja zbroja.'), nl, nl,
        write('** nowy przedmiot w ekwipunku: zbroja **'), nl, nl,
        assert(trzymane(zbroja)),
        write('Rycerz: Dziękuję kowalu, interesy z tobą to przyjemność.'), nl,
        assert(zakończone(kowal_ekwipunek)), !.

/* uzyj: */

przeczytaj(list) :-
        write('Treść listu:'), nl, nl,
        write('--------------------------------------------------------------------------------'), nl,
        write('Tak jak mówiłem - zemsta jest słodka'), nl,
        write('Za to, co zrobiłeś, zapłacisz życiem w przyszłości Ty, a teraz twoja córka'), nl,
        write('Zapamiętaj, że to ja jestem królem, a nie Ty'), nl,
        write('Pozdrawiam, MK'), nl,
        write('--------------------------------------------------------------------------------'), nl, !.

przeczytaj(_) :-
        write('Nie masz takiego przedmiotu'), nl, !.

/* wybudz: */

obudź(masztalerz) :-
        lokalizacja(pokoj),
        zakończone(wybudzenie_masztalerza),
        write('Masztalerz został juz wybudzony'), nl, !.

obudź(masztalerz) :-
        lokalizacja(pokoj),
        trzymane(woda),
        write('Masz już wodę, teraz niestety przychodzi gorsza część zadania'), nl,
        write('Musisz oblać ją masztalerza...'), nl,
        write('Wpisz komendę \'oblej.\', aby to zrobić'), nl, !.

obudź(masztalerz) :-
        lokalizacja(pokoj),
        not(trzymane(woda)),
        write('Weź wodę połozoną w kącie pokoju (komenda podnieś(woda))'), nl,
        write('Wykorzystasz ją do polania masztalerza'), nl,
        write('Niestety, to jedyny znany sposób, w jaki udało się go kiedykolwiek wybudzić'), nl,
        write('Kiedy już będziesz ją miał, ponownie wpisz komendę \'obudź(masztalerz)\''), nl, !.

obudź(_) :-
        write('Nie ma takiej akcji'), nl, !.

oblej :-
        lokalizacja(pokoj),
        trzymane(woda),
        write('Kiedy klikniesz enter, polejesz wodą masztalerza'), nl,
        write('Rób to tak długo, jak długo będzie pozostawał w śnie'), nl,
        write('Kliknij \'enter\''), nl,
        get_single_char(_),
        write('Ani drgnie! Spróbuj jeszcze raz!'), nl,
        get_single_char(_),
        write('Wciąż śpi? Jak to w ogóle jest możliwe?'), nl,
        get_single_char(_),
        write('No dobra, ostatnia szansa!'), nl,
        get_single_char(_),
        write('Masztalerz: CO TY ROBISZ?!'), nl,
        write('Ty: Księżniczka została porwana! Potrzebuję jednego ze stajennych koni'), nl,
        write('M: Kto ją porwał?'), nl,
        write('T: Brat króla, MK'), nl,
        write('M: O nie!'), nl,
        write('   Sytuacja nie będzie prosta. Potrzebujesz najszybszego z naszych koni. Ale..'), nl,
        write('   Nie do końca wiem, który jest najszybszy. Musisz je przetestować'), nl,
        write('   Masz tu klucze do stajni'), nl, nl,
        write('*masztalerz wkłada klucze do Twojej kieszeni*'), nl, nl,
        write('M: Sytuacja jest ciężka, to prawda. Ale szczerze?'), nl,
        write('   Co jak co, ale ja wciąż jestem śpiący. Idź, dasz radę sobie sam'), nl,
        write('   Powodzenia!'), nl, nl,
        write('Klucze pojawiły się w Twoim ekwipunku'), nl,
        write('Przejdź do stajni i spróbuj otworzyć nimi drzwi'), nl,
        assert(trzymane(klucze)),
        assert(zakończone(wybudzenie_masztalerza)), !.

oblej :-
        lokalizacja(pokoj),
        not(trzymane(woda)),
        write('Nie masz wody, aby móc to zrobić'), nl, !.

oblej :-
        write('Nie ma takiej akcji'), nl, !.

otwórz :-
        lokalizacja(stajnia),
        trzymane(klucze),
        assert(połączenie(stajnia, konie)),
        assert(w(zefir, konie)),
        assert(w(jutrznia, konie)),
        assert(w(fantazja, konie)),
        assert(w(heros, konie)),
        write('Otworzyłeś drzwi do pokokju z końmi'), nl,
        write('Spróbuj teraz wejść do środka'), nl, !.

otwórz :-
        lokalizacja(stajnia),
        not(trzymane(klucze)),
        write('Musisz zdobyć klucze, aby otworzyć ten pokój'), nl, !.

otwórz :-
        write('Nie ma takiej akcji'), nl, !.

nakarm(jutrznia, marchewki) :-
        lokalizacja(konie),
        trzymane(marchewki),
        write('Udało się! To ulubiony pokarm Jutrznii!'), nl,
        write('Zdecydowanie Cię polubiła'), nl,
        assert(oswojony(jutrznia)),
        czy_wszystkie_oswojone, !.

nakarm(fantazja, marchewki) :-
        lokalizacja(konie),
        trzymane(marchewki),
        write('Udało się! To ulubiony pokarm Fantazji!'), nl,
        write('Zdecydowanie Cię polubiła'), nl,
        assert(oswojony(fantazja)),
        czy_wszystkie_oswojone, !.

nakarm(zefir, cukier) :-
        lokalizacja(konie),
        trzymane(cukier),
        write('Udało się! To ulubiony pokarm Zefira!'), nl,
        write('Zdecydowanie Cię polubił'), nl,
        assert(oswojony(zefir)),
        czy_wszystkie_oswojone, !.

nakarm(heros, cukier) :-
        lokalizacja(konie),
        trzymane(cukier),
        write('Udało się! To ulubiony pokarm Herosa!'), nl,
        write('Zdecydowanie Cię polubił'), nl,
        assert(oswojony(heros)),
        czy_wszystkie_oswojone, !.

nakarm(X, Y) :-
        lokalizacja(konie),
        w(X, konie),
        trzymane(Y),
        write('To nie jest ulubiony pokarm tego konia'), nl,
        write('Spróbuj czegoś innego'), nl, !.

nakarm(_,_) :-
        write('Nie ma takiej akcji'), nl, !.

czy_wszystkie_oswojone :-
        oswojony(jutrznia),
        oswojony(fantazja),
        oswojony(zefir),
        oswojony(heros), nl,
        assert(zakończone(oswajanie)),
        write('Wszystkie konie są już oswojone. Możesz teraz przejechać się na każdym'), nl,
        write('z nich i wybrać najszybszego. Użyj do tego komendy: \'jedź(imię_konia).\''), nl,
        write('Pamiętaj, aby przejechać się na każdym koniu'), nl, !.

czy_wszystkie_oswojone.

jedź(heros) :-
        lokalizacja(konie),
        oswojony(heros),
        write('Wow, ale on jest szybki.'), nl,
        write('Przejechałeś na nim tor obok stajni w: 10 sekund!'), nl,
        assert(sprawdzony(heros)),
        czy_wszystkie_sprawdzone, !.

jedź(jutrznia) :-
        lokalizacja(konie),
        oswojony(jutrznia),
        write('Co on taki wolny?'), nl,
        write('Przejechałeś na nim tor obok stajni w: 40 sekund!'), nl,
        assert(sprawdzony(jutrznia)),
        czy_wszystkie_sprawdzone, !.

jedź(fantazja) :-
        lokalizacja(konie),
        oswojony(fantazja),
        write('Czy ty w ogólne zdążyłeś na niego wsiąść?!'), nl,
        write('Przejechałeś na nim tor obok stajni w: 6 sekund!'), nl,
        assert(sprawdzony(fantazja)),
        czy_wszystkie_sprawdzone, !.

jedź(zefir) :-
        lokalizacja(konie),
        oswojony(zefir),
        write('Nie jest ani źle, ani dobrze...'), nl,
        write('Przejechałeś na nim tor obok stajni w: 20 sekund!'), nl,
        assert(sprawdzony(zefir)),
        czy_wszystkie_sprawdzone, !.

jedź(_) :-
        write('Nie ma takiej akcji'), nl, !.

czy_wszystkie_sprawdzone :-
        lokalizacja(konie),
        sprawdzony(jutrznia),
        sprawdzony(fantazja),
        sprawdzony(zefir),
        sprawdzony(heros), nl,
        write('Wszystkie konie zostały sprawdzone. Teraz musisz wybrać najszybszego.'), nl,
        write('Użyj do tego komendy: \'wybierz(imię_konia)\''), nl,
        write('Pamiętaj - n a j s z y b s z e g o'), nl, !.

czy_wszystkie_sprawdzone.

wybierz(fantazja) :-
        lokalizacja(konie),
        sprawdzony(jutrznia),
        sprawdzony(fantazja),
        sprawdzony(zefir),
        sprawdzony(heros),
        assert(trzymane(fantazja)),
        assert(zakończone(wybor_konia)),
        write('Jedyny słuszny wybór!'), nl,
        write('Zakończyłeś zadanie związane z wyborem konia.'), nl,
        write('Możesz opuścić stajnie'), nl, 
        możliwe_przejścia(konie), !.

wybierz(X) :-
        lokalizacja(konie),
        write('Nie powiem Ci, który koń jest najszybszy...'), nl,
        write('Powiem Ci tylko, że to na pewno nie ten'), nl, !.

wybierz(_) :-
        write('Nie ma takiej akcji'), nl, !.

/*gry: */

zagraj :-
        lokalizacja(mury_zamku_wroga),
        write('Gdy naciśniesz enter czas zacznie się odmierzać,'), nl,
        write('naciśnij go po raz kolejny po upływie 10 sekund, aby wygrać.'), nl,
        write('Możesz pomylić się o sekundę'), nl, nl,
        get_single_char(_),
        write('start'), nl,
        get_time(T_start),
        get_single_char(_),
        get_time(T_end),
        write('stop'), nl,
        Time is T_end - T_start,
        write('Twoj wynik: '), write(Time), nl,
        ((Time > 9, Time < 11) -> 
        write('Gratulacje, wygrałeś!'), nl, nl, retract(lokalizacja(mury_zamku_wroga)),
        assert(lokalizacja(korytarz_wroga)),
        !, spójrz ; write('Porażka, spróbuj jeszcze raz!'), nl, !, nl).


zagraj :-
        lokalizacja(wartownia),
        not(zakończone(wartownik_zabity)),
        write('Gdy naciśniesz enter zostanie wygenerowany losowy napis o długości 30 znaków,'), nl,
        write('a czas zacznie się odmierzać,'), nl,
        write('twoim zadaniem jest przepisanie tego wyrazu oraz naciśnięcie klawisza enter.'), nl,
        write('Masz na to 25 sekund. Powodzenia!'), nl, nl,
        get_single_char(_),
        write('   '), generuj, nl,
        flush_output,
        get_time(T_start),
        read_line_to_codes(user_input, Codes),
        atom_codes(Input, Codes),
        get_time(T_end),
        Time is T_end - T_start,
        ((Time < 25, Result = Input) -> 
        write('Gratulacje, wygrałeś!'), nl, nl,
        assert(w(klucz, wartownia)),
        assert(zakończone(wartownik_zabity)),
        !, spójrz ; write('Porażka, spróbuj jeszcze raz!'), nl, nl).


zagraj :-
        lokalizacja(szafka),
        write('Gdy naciśniesz enter, gra się rozpocznie.'), nl,
        write('W losowym momencie na ekranie pojawi się napis STOP!.'), nl,
        write('Musisz wówczas jak najszybciej kliknąć enter.'), nl,
        write('Jeśli twój czas reakcji będzie poniżej 0.3 sekundy,'), nl,
        write('uda ci się podnieść złotą monetę. Powodzenia!'), nl, nl,
        get_single_char(_),
        write('START'), nl, nl,
        random(3, 10, Wait),
        sleep(Wait),
        write('STOP!'), nl,
        get_time(T_start),
        get_single_char(_),
        get_time(T_end),
        Time is T_end - T_start,
        write('Twoj wynik: '), write(Time), nl,
        ((Time > 0.05, Time < 0.30) -> 
        write('Gratulacje, udało ci się!'), nl, nl,
        retract(w(złota_moneta, szafka)),
        assert(trzymane(złota_moneta)), ! ; write('Porażka, może uda się następnym razem!'), nl, !, nl).

zagraj :-
        lokalizacja(droga_do_wroga),
        write('Aby pokonać bandziorów, potrzebne są szybkie i zwinne ruchy.'), nl,
        write('Kliknij enter, a następnie w ciągu maksymalnie 10 sekund klikaj na zmianę \'a\' i \'d\' najszybciej jak potrafisz.'), nl,
        write('Przed upływem 10 sekund musisz zatwierdzić swój rezultat stawiając kropkę i klikając enter.'), nl,
        write('Potrzebujesz minimum 85 kliknięć, aby wygrać walkę. Powodzenia!'), nl,
        get_single_char(_),
        get_single_char(_),
        write('START'), nl, nl,
        get_time(T_start),
        read(X),
        get_time(T_end),
        Time is T_end - T_start,
        write('Twoj czas: '), write(Time), nl,
        string_length(X, Score),
        write('Twoj wynik: '), write(Score), nl, nl,
        ((Time < 10, Score > 84) -> 
        write('Gratulacje, udało ci się!'), nl, nl,
        write('Pokonałeś wszystkich bandziorów, nie będą więcej ci przeszkadzać.'), nl,
        write('Możesz kontynuować swoją podróż do zamku wroga.'), nl,
        assert(zakończone(bandziory)), ! ; write('Porażka, spróbuj ponownie!'), nl, nl, zagraj).

zagraj :-
        write('W tym miejscu nie ma żadnej minigry.'), nl.

/* Polozenia przedmiotow: */

w(miotła, składzik).
w(drabina, składzik).
w(wiadro, składzik).

w(rękawice, szafka).
w(ścierka, szafka).
w(złota_moneta, szafka).
w(mlotek, szafka).


w(list, pralnia).

w(marchewki, kuchnia).
w(cukier, kuchnia).

w(woda, pokoj).

/*predykat generujący losowy string o długości 30 znaków*/

generuj :-
    Wyjście = '',
    losowy_napis(Wyjście,Wynik,0),
    write(Wynik).

losowy_napis(Wyjście,Wynik,29):- !,
    Znaki = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N',
        'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', 'a', 'b', 'c', 'd', 'e',
        'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z'],

    random(0, 52, Losowa_wartosc),
    nth0(Losowa_wartosc, Znaki, Losowy_znak),
    atom_concat(Losowy_znak,Wyjście,Wynik).

losowy_napis(Wyjście,Wynik,CharNum) :-
    CharNum \= 29,

    Znaki = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N',
        'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', 'a', 'b', 'c', 'd', 'e',
      'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z'],
    random(0, 52, Losowa_wartosc),
    nth0(Losowa_wartosc, Znaki, Losowy_znak),
    atom_concat(Losowy_znak,Wyjście,Concat),
    Policz is CharNum + 1,
    losowy_napis(Concat,Wynik,Policz).