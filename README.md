CrtlMoto is an E-commerce created by me to pass Tsw Exam.

## Database

Lo schema e i dati iniziali sono in `database/crtlmoto.sql`.

Credenziali demo:

- Admin: `admin@crtlmoto.it` / `password123`
- Cliente: `lcretella23@gmail.com` / `password123`

Lo script include prodotti, utenti, carrelli, ordini gia effettuati, pagamenti, immagini, veicoli, newsletter e codici sconto. I dettagli ordine salvano `prezzo_acquisto`, cosi gli ordini storici restano coerenti anche se il prezzo del prodotto cambia.

## Build e deploy Tomcat

Il progetto Maven si trova in `webApps/CrtlMoto`.

```bash
cd webApps/CrtlMoto
./mvnw clean package
```

Il WAR viene generato in `webApps/CrtlMoto/target/CrtlMoto-1.0-SNAPSHOT.war` e puo essere copiato nella cartella `webapps` di una installazione Tomcat compatibile con Jakarta Servlet 6.

Prima dell'avvio creare il database eseguendo `database/crtlmoto.sql`.

La connessione usa valori di default locali, ma in Tomcat esterno puo essere configurata senza ricompilare impostando:

- `CRTLMOTO_DB_URL`
- `CRTLMOTO_DB_USER`
- `CRTLMOTO_DB_PASSWORD`

Esempio:

```text
CRTLMOTO_DB_URL=jdbc:mysql://localhost:3306/crtlmoto?serverTimezone=UTC
CRTLMOTO_DB_USER=root
CRTLMOTO_DB_PASSWORD=root123
```

Per HTTPS configurare il connettore SSL in `conf/server.xml` di Tomcat con un keystore valido. L'applicazione imposta header di sicurezza e cookie `HttpOnly`, `Secure` e `SameSite=Lax` quando lavora dietro HTTPS.

## Accessibilita

Controlli applicati:

- campi principali con `label`;
- immagini prodotto con `alt`;
- bottoni galleria raggiungibili da tastiera;
- messaggio disponibilita AJAX con `aria-live`;
- label visibili solo agli screen reader per le quantita nel carrello.
