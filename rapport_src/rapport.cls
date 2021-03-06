\LoadClass[a4paper,11pt]{article} % Classe du document

%--------------------- Packages ------------------------

\RequirePackage[french]{babel} %Langue du document
\RequirePackage[utf8]{inputenc} %Caractères spéciaux
\RequirePackage[section]{placeins}%Pour placement de section
\RequirePackage[T1]{fontenc} %Quelques lettres qui sont pas inclus dans UTF-8
\RequirePackage{mathtools} %Paquet pour des équations et symboles mathématiques
\RequirePackage{siunitx} %Pour écrire avec la notation scientifique (Ex.: \num{2e+9})
\RequirePackage{float} %Pour placement d'images
\RequirePackage{graphicx} %Paquet pour insérer des images
\RequirePackage[justification=centering]{caption} %Pour les légendes centralisées
\RequirePackage{subcaption}
\RequirePackage{wallpaper}
\RequirePackage{nomencl}
%\makenomenclature
\RequirePackage{fancyhdr}
%\pagestyle{fancy}
%\fancyheadoffset{1cm}
%\setlength{\headheight}{2cm}
\RequirePackage{url}
\RequirePackage[hidelinks]{hyperref}%Paquet pour insérer légendes dans des sous-figures comme Figure 1a, 1b
\RequirePackage[left=2.5cm,right=2.5cm,top=2cm,bottom=3.5cm]{geometry} %Configuration de la page

\usepackage{sectsty}
\usepackage{xcolor}

% On définit les deux couleurs utilisées
\definecolor{couleur_section}{RGB}{0,0,128}
\definecolor{couleur_subsection}{RGB}{0,128,255}

% On personnalise chacun des titres à l'aide des commandes "sectionfont", "subsectionfont", etc.
\sectionfont{\color{couleur_section}}
\subsectionfont{\color{couleur_subsection}}
\subsubsectionfont{\itshape}
%-------------------- Informations sur le  ----------------------

\newcommand{\UE}[1]{\renewcommand{\UE}{#1}}
\newcommand{\sujet}[1]{\renewcommand{\sujet}{#1}}
\newcommand{\titre}[1]{\renewcommand{\titre}{#1}}
\newcommand{\enseignant}[1]{\renewcommand{\enseignant}{#1}}
\newcommand{\eleves}[1]{\renewcommand{\eleves}{#1}}

\newcommand{\fairemarges}{
\makenomenclature
\pagestyle{fancy}
\fancyheadoffset{1cm}
\setlength{\headheight}{2cm}
\lhead{\includegraphics[scale=0.1]{logos/logo.png}} %Affichage de l'image au top de la page
\rhead{\nouppercase{\leftmark}}
\rfoot{\thepage}
\cfoot{Digital signal processing}
\lfoot{TS114}
}

\newcommand{\fairepagedegarde}{
\begin{titlepage}

\ThisLRCornerWallPaper{0.6}{logos/logo_background.png}
	\centering %Centraliser le contenu
	\includegraphics[width=0.5\textwidth]{logos/logo.png}\par\vspace{1cm} %Insertion du logo
	{\scshape\Large \UE \\ \sujet \\ Rapport\par} %sous-titre
	\vspace{1cm}%Espace de 1cm
    \rule{\linewidth}{0.2 mm} \\[0.4 cm]
	{\huge\bfseries \titre \par} \
    \rule{\linewidth}{0.2 mm} \\[1.5 cm]
	\vspace{1cm}%Espace de 3cm
    
	\begin{minipage}{0.5\textwidth} %Minipage pour faire deux colonnes
		\begin{flushleft} \large %Envoyer à gauche
		\textbf{Rédigé par :}\\ %Pour le titre au dessus des noms à gauche
        \eleves\\ %Remplacer pour chacun
		\end{flushleft}
	\end{minipage}
	~
	\begin{minipage}{0.4\textwidth}
		\begin{flushright} \large
		\textbf{Encadrants :} \\
		 \enseignant \\
		\end{flushright}
	\end{minipage}\\[4cm]
    
	\vfill
	{\large Octobre 2021\par} %Affichage de la date

\end{titlepage}
}

\newcommand{\tabledematieres}{

\tableofcontents
\newpage

}

\newcommand{\insererfigure}[4]{
\begin{figure}[ht]
\centering
\includegraphics[height=#2]{#1}
\caption{#3}
\label{fig: #4}
\end{figure}
}