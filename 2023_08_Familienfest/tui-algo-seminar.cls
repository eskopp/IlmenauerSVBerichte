\ProvidesClass{tui-algo-seminar}

% Process all document class options by passing them to lipics.
\DeclareOption*{
  \PassOptionsToClass{\CurrentOption}{lipics-v2021}
}
\DeclareOption{german}{
  \PassOptionsToPackage{german}{babel}
  \let\tuiAlgoSeminarGerman\relax
}
\ProcessOptions\relax

% Now we load the lipics class.
\LoadClass{lipics-v2021}

\RequirePackage{babel}

% -----------------------------------
%  Modifications to lipics-v2021.cls
% -----------------------------------

\makeatletter

%TU Ilmenau colours




% Simplify \author definition.
% We also redefine \title to save the title also somewhere else.
% The macros \theAuthor, \theTitle are used in the running headers.
\def\author#1{\gdef\@author{#1}\gdef\theAuthor{#1}}
\def\title#1{\gdef\@title{#1}\gdef\theTitle{#1}}

% Add definition of a seminar name and semester.
\newcommand\seminar[1]{\def\@seminarName{#1}}
\newcommand\semester[1]{\def\@semester{#1}}

% Clean up \maketitle titlepage.
\def\@maketitle{%
  \newpage
  \null\vskip-\baselineskip
  \vskip-\headsep
  \@titlerunning
  \@authorrunning
  \parindent\z@ \raggedright
    {
      \parbox[top]{0.70\linewidth}{
              \large\sffamily
              Ilmenauer SV\\
              % Print the seminar name.
              \ifx\@seminarName\undefined%
                \todo{Specify the seminar name with \texttt{\textbackslash seminar\{\}}!}%
              \else{\emph{\@seminarName}}%
              \fi\\
              % Print the semester.
              \ifx\@semester\undefined%
                \todo{Specify the semester with \texttt{\textbackslash semester\{\}}!}%
              \else{\@semester}%
              \fi
            }
      \hfill
      \parbox[top]{0.25\linewidth}{\includegraphics[width=\linewidth]{IlmenauerSV.png}}
      \par
    }
    \vspace{.5cm}
    % Print the title.
    {%
      \LARGE\sffamily\bfseries\mathversion{bold}\@title
      \if!\@subtitle!\else{\\\Large\sffamily\bfseries\mathversion{bold}\@subtitle}\fi
      \par%
    }%
    \vskip 1em
    % Print the author’s name.
    \ifx\@author\orig@author
      \todo{Specify an \texttt{\textbackslash author\{\}}!}%
    \else
      {\def\thefootnote{\@arabic\c@footnote}%
       \setcounter{footnote}{0}%
       \fontsize{12}{12}\selectfont\@author}%
    \fi
    \bgroup
      \immediate\openout\tocfile=\jobname.vtc
      \protected@write\tocfile{
			\let\footnote\@gobble
			\let\thanks\@gobble
			\def\footnotemark{}
			\def\and{and }%
			\def\,{ }
			\def\\{ }
		}{%
	        \string\contitem
	        \string\title{\@title \if!\@subtitle!\else\subtitleseperator \@subtitle\fi}%
	        \string\author{\@authorsfortoc}%
	        \string\page{\@ArticleNo:\thepage--\@ArticleNo:\number\numexpr\getpagerefnumber{TotPages}}}%
      \closeout\tocfile
    \egroup
  \par} % end maketitle

\renewenvironment{abstract}{%
  \vskip\topmattervskip\bigskipamount
  \noindent
  \rlap{\color{lipicsLineGray}\vrule\@width\textwidth\@height1\p@}%
  \hspace*{7mm}\fboxsep1.5mm\colorbox[rgb]{1,1,1}{\raisebox{-0.4ex}{%
    \large\selectfont\sffamily\bfseries\abstractname}}%
  \vskip3\p@
  \fontsize{9}{12}\selectfont
  \noindent\ignorespaces
  }
  {%
    \vskip\topmattervskip\baselineskip\noindent
    % \ifx\@acknowledgements\@empty\else
    %   \vskip\topmattervskip\baselineskip\noindent
    %   \acknowledgementsHeading\ifx\authoranonymous\relax\textcolor{red}{Anonymous acknowledgements} \else\@acknowledgements\fi
    % \fi
    \protected@write\@auxout{}{\string\gdef\string\@pageNumberEndAbstract{\thepage}}%
  }% end abstract

% Remove \copyrightline definition.
\def\copyrightline{}

% Set running header.
\AtBeginDocument {
  \ifx\theAuthor\undefined
    \authorrunning{\todo{Specify an \texttt{\textbackslash author\{\}}!}}
  \else
    \authorrunning{\theAuthor}
  \fi
  \ifx\theTitle\undefined
    \titlerunning{\todo{Specify a \texttt{\textbackslash title\{\}}!}}
  \else
    \titlerunning{\theTitle}
  \fi
}

\makeatother

% Hide article number and other LIPIcs stuff.
\hideLIPIcs


% -------------
%  Other Stuff
% -------------

\RequirePackage{csquotes}

\RequirePackage{thmtools}

\makeatletter

\def\cleartheorem#1{%
    \expandafter\let\csname#1\endcsname\relax
    \expandafter\let\csname c@#1\endcsname\relax
}

\def\renewNumberedTheorem#1#2#3{%
  \cleartheorem{#1}
  \declaretheorem[name=#2,style=#3,numberwithin=section,sibling=theorem]{#1}
}
\def\renewUnnumberedTheorem#1#2#3{%
  \cleartheorem{#1}
  \declaretheorem[name=#2,style=#3,numbered=no]{#1}
}

\ifx\tuiAlgoSeminarGerman\undefined
\else
% The language is German.
\cleartheorem{theorem}
\declaretheorem[name=Satz,numberwithin=section]{theorem}

\renewNumberedTheorem{lemma}{Lemma}{plain}
\renewNumberedTheorem{corollary}{Korollar}{plain}
\renewNumberedTheorem{proposition}{Proposition}{plain}
\renewNumberedTheorem{conjecture}{Vermutung}{plain}
\renewNumberedTheorem{observation}{Beobachtung}{plain}
\renewNumberedTheorem{exercise}{Übung}{plain}
\renewNumberedTheorem{definition}{Definition}{plain}
\renewNumberedTheorem{example}{Beispiel}{definition}
\renewNumberedTheorem{note}{Notiz}{remark}
\renewUnnumberedTheorem{note*}{Notiz}{remark}
\renewNumberedTheorem{remark}{Bemerkung}{remark}
\renewUnnumberedTheorem{remark*}{Bemerkung}{remark}
\renewNumberedTheorem{claim}{Behauptung}{claimstyle}
\renewUnnumberedTheorem{claim*}{Behauptung}{claimstyle}

\AtBeginDocument{  
  % \renewcommand*{\figurename}{Abbildung}
  % \renewcommand*{\tablename}{Tabelle}
  % \renewcommand*{\abstractname}{Zusammenfassung}
  % \renewcommand*{\examplename}{Beispiel}
  % \renewtheorem{theorem}{Satz}
  % \renewcommand{\refname}{Referenzen}
  % \renewcommand*{\proofname}{Beweis}
  % \renewcommand*{\corollaryname}{Korollar}
	\@ifpackageloaded{algorithm2e}{
		\@ifpackagelater{algorithm2e}{2009/11/17}{
      \renewcommand*{\algorithmcfname}{\sffamily\bfseries{}Algorithmus}
      \renewcommand*{\@algocf@procname}{\sffamily\bfseries{}Prozedur}
    }{}
  }{}
}
\fi

\makeatother


% -------------------
%  Required Packages
% -------------------

\RequirePackage{microtype}


% ------
%  Body
% ------

% \todo{…} command
\newcommand\todo[1]{%
  \textcolor{red}{\textbf{\small TODO:} #1}
}


% --------------
%  Bibliography
% --------------

\bibliographystyle{plainurl}