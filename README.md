CrtlMoto is an E-commerce created by me to pass Tsw Exam.

## Database

Lo schema e i dati iniziali sono in `database/crtlmoto.sql`.

Credenziali demo:

- Admin: `admin@crtlmoto.it` / `password123`
- Cliente: `lcretella23@gmail.com` / `password123`

Lo script include prodotti, utenti, carrelli, ordini gia effettuati, pagamenti, immagini, veicoli, newsletter e codici sconto. I dettagli ordine salvano `prezzo_acquisto`, cosi gli ordini storici restano coerenti anche se il prezzo del prodotto cambia.

## Accessibilita

Controlli applicati:

- campi principali con `label`;
- immagini prodotto con `alt`;
- bottoni galleria raggiungibili da tastiera;
- messaggio disponibilita AJAX con `aria-live`;
- label visibili solo agli screen reader per le quantita nel carrello.
