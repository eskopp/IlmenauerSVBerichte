# Ilmenauer SV
Verschiedene Berichte von Turnieren und anderen Veranstaltungen. Alle Berichte sind in der [Ilmenauer Schachverein Cloud](https://cloud.ilmenauer-schachverein.de) verfügbar.  

## Inhalt
| Monat   | Event                                  | Link |
|---------|----------------------------------------|------|
| 08.2023 | Familienfest                           |  [Link](2023_08_Familienfest)    |
| 08.2023 | Ilmenauer Schnellschachturnier         |  [Link](2023_08_Ilmenauer_Schnellschachturnier)    |
| 09.2023 | RSR Ausbildung                         |  [Link](2023_09_RSR_Ausbildung)    |
| 10.2023 | 28. Magdeburger A-Open 2023            |  [Link](2023_10_Magdeburg_Open_28)    |
| 10.2023 | Mannschaft Schnellschach Königsee 2023 |  [Link](2023_10_Mannschaftsschnellschachpokal-Schach-Königssee)    |
| 10.2023 | RSR Ausbildung Prüfungsergebnisse      |  [Link](2023_10_RSR_Ausbildung_Nachtrag)    |
| 10.2023 | Vereinspräsentation TU Ilmenau WS23/24 |  [Link](2023_10_Vereinspräsentation_TUIlmenau_WS2324)    |
| 11.2023 | 1. Halloween Blitz 2023                |  [Link](2023_11_Halloween_Blitz)    |
| 11.2023 | Kreiseinzelmeisterschaft der Jugend U10-U18 2023             |  [Link](2023_11_KJEM_IK)    |
| 12.2023 | 1. Nikolaus Blitz 2023                 |  [Link](2023_12_Nikolaus_Blitz)    |


# Git 
Sie können sich das Git hier herunterladen: [https://github.com/eskopp/IlmenauerSV/archive/refs/heads/main.zip](https://github.com/eskopp/IlmenauerSV/archive/refs/heads/main.zip)

Alternativ können Sie das Git-Repository clonen:

- mit HTTPS: 
```bash
https://github.com/eskopp/IlmenauerSV.git
```

- mit SSH:

```bash
git@github.com:eskopp/IlmenauerSV.git
```


Wenn Sie möchten, können Sie eigene Berichte für den Ilmenauer Schachverein einreichen oder an anderen Projekten mitarbeiten. Es ist auch möglich, Fehler zu melden. Nutzen Sie dazu bitte das Formular für ein Issue, um uns die Bearbeitung zu erleichtern.

# LaTeX
LaTeX wird jedes Mal in einer Linux-VM neu installiert, um sicherzustellen, dass es zu keinen Altlasten im System kommt. Alle Berichte werden mit LaTeX wie folgt erstellt:

```bash
 pdflatex -interaction=nonstopmode -halt-on-error *.tex
```
Da es sich nicht um eine wissenschaftliche Arbeit handelt und nur um einfache Berichte geht, wird bewusst auf ``biber`` und ähnliche Tools verzichtet.


# Workflows
Die Workflows werden bei zwei verschiedenen Events innerhalb eines ``pull`` getriggert:

1. Der Bericht oder eine Datei im Ordner wird geändert, gelöscht oder erstellt.

2. Der Workflow selbst wird geändert.

```yml
on:
  push:
    branches:
      - main
    paths:
      - "BERICHT_NAME/**"
      - ".github/workflows/**"

jobs:
  build:
    runs-on: ubuntu-latest
```
Anschließend wird LaTeX installiert.

```yml
  - name: Checkout Repository
        uses: actions/checkout@v3

      - name: Set up LaTeX
        run: |
          sudo apt-get install -y texlive-latex-extra
          sudo apt-get install -y texlive-fonts-recommended
         ...
```

Theoretisch könnte man das auch über ``xu-cheng/latex-action@v3`` ([LINK](https://github.com/marketplace/actions/github-action-for-latex)) vereinfachen. Da die Templates jedoch fehleranfällig sind, wird dies hier manuell erledigt.


Anschließend wird das PDF erstellt
```yml
      - name: Build PDFs
        run: |
          cd BERICHT_ORDNER
          pdflatex -interaction=nonstopmode -halt-on-error BERICHT_NAME.tex
          ls -aril
          cp BERICHT_NAME.pdf ../ISV_BERICHT_NAME.pdf
          cd ..
```

 Und als Artifact zur Verfügung gestellt.
```yml
  - name: Upload PDF Artifact
        uses: actions/upload-artifact@v3
        with:
          name: BERICHT_ORDNER
          path: ISV_BERICHT_NAME.pdf
```

Um Daten auf eine Nextcloud via Skript zu laden, sollte man WebDAV nutzen.

```yml
 - name: Install WebDAV client
        run: sudo apt-get install -y davfs2
```

Nun beginnt der Upload der Datei in die verschiedenen Ordner der Nextcloud. Die ``Secrets`` sind als Keys bei GitHub hinterlegt und können nicht eingesehen werden.
```yml
 - name: Upload zur xxx Cloud
        run: |
          EXTCLOUD_URL="${{ secrets.ISV_WEBDAV_BASE }}/${{ secrets.ISV_WEBDAV_PATH }}/"
          USERNAME="${{ secrets.ISV_WEBDAV_USER }}"
          PASSWORD="${{ secrets.ISV_WEBDAV_PASSWORD }}"
          PDF_FILE="ISV_BERICHT_NAME.pdf"
          
          HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" -u "$USERNAME:$PASSWORD" -T "$PDF_FILE" "$EXTCLOUD_URL")
      
          if [ $HTTP_STATUS -eq 201 ] || [ $HTTP_STATUS -eq 204 ]; then
            echo "PDF-Datei wurde erfolgreich hochgeladen oder aktualisiert."
          else
            case $HTTP_STATUS in
              400)
                echo "Fehlerhafter Request. Bitte überprüfen Sie die Anfrageparameter."
                ;;
              401)
                echo "Authentifizierung fehlgeschlagen. Bitte überprüfen Sie die Zugangsdaten."
                ;;
              403)
                echo "Zugriff verweigert. Stellen Sie sicher, dass Sie die erforderlichen Berechtigungen haben."
                ;;
              404)
                echo "Die Nextcloud-URL oder der angegebene Ordner existiert nicht."
                ;;
              *)
                echo "Fehler beim Hochladen/Aktualisieren der PDF-Datei. Serverantwort-Statuscode: $HTTP_STATUS"
                exit 1  
                ;;
            esac
          fi

```