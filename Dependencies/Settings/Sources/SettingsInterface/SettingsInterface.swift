//
//  SettingsInterface.swift
//  
//
//  Created by Kamil Wójcicki on 22/10/2023.
//

import Foundation

public enum ActiveSheet: Identifiable {
    case privacyPolicy
    case termsAndConditions
    case ourTeam
    
    public var id: String {
        switch self {
        case .privacyPolicy:
            "privacyPolicy"
        case .termsAndConditions:
            "termsAndConditions"
        case .ourTeam:
            "ourTeam"
        }
    }
    
    public var description: String {
        switch self {
        case .privacyPolicy:
            return """
            1. Zbierane Informacje

                Aplikacja SMART HOME może zbierać następujące informacje:

            • Dane osobowe, takie jak imię, adres e-mail, numer telefonu, które użytkownik dobrowolnie udostępnia.
            
            • Informacje o urządzeniach podłączonych do aplikacji, takie jak typ, identyfikator, status i dane z nimi związane.
            
            • Informacje o użyciu aplikacji, takie jak historie uruchomionych urządzeń, harmonogramy zadań, itp.
            
            • Informacje związane z lokalizacją w celu dostarczenia funkcji związanych z geolokalizacją.
            
            2. Wykorzystanie Informacji

                Zebrane informacje mogą być wykorzystane do:

            • Dostarczania, konfigurowania i personalizacji usług SMART HOME.
            
            • Umożliwienia użytkownikowi planowania zadań i zdalnego zarządzania urządzeniami.
            
            • Analizy danych w celu ulepszania funkcji i wydajności aplikacji.
            
            • Wysyłania powiadomień i aktualizacji dotyczących usług SMART HOME.
            
            3. Udostępnianie Informacji

                Informacje użytkowników nie będą udostępniane, sprzedawane ani wynajmowane stronom trzecim bez ich zgody, chyba że wymaga tego prawo.

            4. Bezpieczeństwo

                Podjęliśmy środki bezpieczeństwa, aby chronić informacje użytkowników przed utratą, nieautoryzowanym dostępem, zmianami lub ujawnieniem.

            5. Zmiany w Polityce Prywatności

                Polityka Prywatności może być okresowo aktualizowana. Informacje o zmianach będą udostępniane użytkownikom poprzez aktualizacje aplikacji.
            """
        case .termsAndConditions:
            return """
            1.Korzystanie z Aplikacji

                Korzystanie z aplikacji SMART HOME oznacza akceptację niniejszych Zasad i Warunków oraz Polityki Prywatności.

            2.Zadania i Urządzenia

                Użytkownik może planować zadania i zdalnie zarządzać urządzeniami za pomocą aplikacji SMART HOME zgodnie z funkcjonalnościami dostępnymi w aplikacji.

            3.Odpowiedzialność

                Aplikacja SMART HOME nie ponosi odpowiedzialności za ewentualne szkody wynikłe z błędów, przerw w dostępie, utraty danych lub innych problemów technicznych.

            4.Zmiany w Usługach

                Aplikacja SMART HOME może wprowadzać zmiany w funkcjonalnościach i usługach bez wcześniejszego powiadomienia użytkowników.

            5.Usunięcie Konta

                Użytkownik ma prawo usunąć swoje konto w dowolnym momencie, jednak może to skutkować utratą dostępu do niektórych funkcji aplikacji.

            6.Prawa Autorskie

                Wszystkie prawa autorskie i inne prawa własności intelektualnej związane z aplikacją SMART HOME należą do jej właściciela.
            """
        case .ourTeam:
            return ""
        }
    }
}

