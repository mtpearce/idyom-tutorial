;;;; IDyOM Tutorial ========================================================================
;;;; =======================================================================================

;;; IDyOM documentation: https://github.com/mtpearce/idyom/wiki
;;;
;;; This script is available from: https://github.com/mtpearce/idyom-tutorial

;;; Contents
;;; 
;;; Part A. Preliminaries
;;; Part B. The database
;;; Part C. Viewpoints
;;; Part D. Running IDyOM


;;; ======================================================================================== 
;;; Part A. Preliminaries

;; -----------------------------------------------------------------------------------------
;; (i) Install IDyOM: https://github.com/mtpearce/idyom/wiki/Installation
;;
;;     Ensure you are using v1.7.1 or higher


;; -----------------------------------------------------------------------------------------
;; (ii) Using Lisp
;;
;; IDyOM is written in Common Lisp (LISt Processing), the standard
;; modern dialect of the lisp programming language invented in 1958 by
;; John McCarthy at MIT and popular in AI research until the early
;; 2000s. Lisp has many attractive features: functions as first-class
;; objects, dynamic typing, macros, allowing multi-paradigm functional
;; and imperative programming styles, object-oriented programming
;; using generic functions (rather than the more limited Java-style
;; message passing), a meta-object protocol, a REPL (read-eval-print
;; loop), and native compilation.
;;
;; You don't need to know Lisp to use IDyOM but you will be running
;; lisp functions, so a little bit of understanding is helfpul.
;;
;; In Lisp, both data and functions appear as lists of elements
;; separated by spaces (without commas) enclosed in parentheses,
;; making for a simple and highly parsimonious syntax. By default a
;; list is evaluated, meaning its contents are inspected for further
;; processing but evaluation can be prevented by quoting the
;; list. E.g., '(1 2 3)
;; 
;; Functions use prefix notation, which means that the function name
;; is the first item in a list followed by the arguments. So where you
;; might expect max(1, 100) --> 100 in other languages, in Lisp you
;; would write (max 1 100) --> 100
;;
;; There is no distinction between operators and functions, so rather
;; than 1 + 100 --> 101 we have (+ 1 100) --> 101
;;
;; In addition to ordinary required arguments to functions, Lisp
;; allows for named 'keyword' arguments, which are optional taking a
;; default value if not specified. Keyword arguments are expressed
;; using symbols prefixed with a colon. For example, to find the
;; element d in the list '(a b c d e) starting with the second element
;; (NB: like most programming languages, Lisp uses zero indexing, so
;; the first element of a list has index 0, the second has index 1,
;; and so on):
;; 
;; (find 'd '(a b c d e) :start 1)
;; 
;; Note that functions can be passed as arguments.
;; 
;; (find 'd ((a 1) (b 2) (c 3) (d 4) (e 5)) :key #'first)
;;
;; where (first '(d 4)) --> d 
;;
;; Lisp provides packages which are useful for encapsulating code and
;; distinguishing the external interface to the package from code that
;; is internal to the package (i.e., not intended to be used
;; externally). When calling lisp functions in a package from another
;; package, the package name is prepended to the function name
;; separated by a colon. For example: (cl:sum 100 1) calls the 'sum'
;; function in the 'cl' package.

;; -----------------------------------------------------------------------------------------
;; Using lisp

;; Common Lisp is an ANSI standard and there are different
;; implementations of the standard - we will be using SBCL (Steel Bank
;; Common Lisp) one of the most popular common lisp implementations.
;;
;; I will be running sbcl inside Emacs which provides a convenient and
;; widely used interface but you could also use Atom, Eclipse, Vim or
;; the terminal, according to your preference.
;;
;; 1. start Emacs
;; 2. type alt-X slime

;; -----------------------------------------------------------------------------------------
;; (iv) loading IDyOM

(start-idyom)


;;; ======================================================================================== 
;;; Part B. The database

;; -----------------------------------------------------------------------------------------
;; (i) IDyOM stores music in an SQL database, which has the following structure. 
;; 
;; Tables
;; - Dataset (dataset-id description timebase midc)
;; - Composition (dataset-id composition-id description timebase)
;; - Event (dataset-id composition-id event-id onset cpitch dur deltast bioi keysig mode barlength pulses phrase tempo dyn ornament voice) 


;; -----------------------------------------------------------------------------------------
;; (ii) Datasets used in this tutorial: 
;; 
;; 19: 6 melodies from Frankland & Cohen (2004, Music Perception, https://doi.org/10.1525/mp.2004.21.4.499)
;; -- The Mulberry Bush
;; -- Three Blind Mice
;; -- Softly Now the Light of Day
;; -- Mary had a Little Lamb
;; -- Tom, Tom, the Piper's Son
;; -- Melody in F (Anton Rubenstein, op. 3, no. 1 for piano)
;; 
;; 3: 91 Alsatian folk songs from the Essen Folk Song Collection (available from: https://kern.humdrum.org/cgi-bin/browse?l=essen/europa/elsass)
;;
;; 16: 237 Chinese folk songs (Shanxi region) from the Essen Folk Song Collection (a subset of: https://kern.humdrum.org/cgi-bin/browse?l=essen/asia/china/shanxi)
;;
;; 2020: A single four voice chorale harmonised by J. S Bach (from: https://kern.humdrum.org/cgi-bin/browse?l=users/craig/classical/bach/371chorales) 


;; -----------------------------------------------------------------------------------------
;; (iii) Importing, inspecting and exporting data

;; Data can be imported from Kern and Midi as follows (adjust the paths to correspond to the right locations on your filesystem): 
 
(db:import-data :krn "~/idyom-tutorial/corpora/FranklandCohen2004/" "Melodies used in the experiments of Frankland and Cohen (2004)." 19)
;; (db:import-data :mid "~/idyom-tutorial/corpora/FranklandCohen2004/" "Melodies used in the experiments of Frankland and Cohen (2004)." 19)

;; there is also a lisp based format exported directly from the database

(db:import-data :lisp "~/idyom-tutorial/corpora/elsass.lisp" "Alsatian folk songs from the Essen Folk Song Collection." 3)
(db:import-data :lisp "~/idyom-tutorial/corpora/shanxi237.lisp" "Chinese folk songs (Shanxi region) from the Essen Folk Song Collection." 16)
(db:import-data :lisp "~/idyom-tutorial/corpora/chorale.lisp" "1 chorale harmonised by J. S. Bach: 4 voices." 2020)

;; Once imported you can print out the properties of the dataset as follows:

(db:describe-dataset 19 :verbose t)

;; Data can be exported in Midi and Lilypond as follows:

(db:export-data (db:get-dataset 19) :mid "~/tmp/")

(db:export-data (db:get-composition 19 0) :mid "~/tmp/")

(db:export-data (db:get-composition 19 0) :ly "~/tmp/")

;; you can also delete datasets

(db:delete-dataset 19)

;; there is also a function for copying datasets while making changes

(db:copy-datasets <target-id> <source-ids> <description> <exclude> <include> <random-subset>) 


;; For more information see: https://github.com/mtpearce/idyom/wiki/Database-management


;;; ======================================================================================== 
;;; Part C. Viewpoints

;; A multiple viewpoint system is a collection of functions that
;; extract different representations of musical sequences. Viewpoints
;; may be basic, derived, linked or threaded.
;;
;; - Basic viewpoints return an attribute of an event (e.g., cpitch, onset, dur)
;;
;; - Derived viewpoints return an attribute derived from a basic attribute (e.g., cpint, ioi)
;;
;; - Linked viewpoints represent the combination of more than one component viewpoint (e.g., (cpitch ioi))
;;
;; - Threaded viewpoints represent values at potentially non-consecutive positions (e.g., pitch interval between notes falling on tactus beats)
;;
;; Examples for Dataset 19, composition 2 - Softly Now the Light of Day

(defvar *softly* (mo:get-music-objects 19 2))

(mo:preview *softly*) 

(vp:viewpoint-sequence 'cpitch *softly*)            ; basic: chromatic pitch
(vp:viewpoint-sequence 'cpint *softly*)             ; derived: chromatic pitch interval
(vp:viewpoint-sequence 'cpintfref *softly*)         ; derived: scale degree (chromatic pitch interval from referent)
(vp:viewpoint-sequence '(cpint cpintfref) *softly*) ; linked: pitch interval x scale degree
(vp:viewpoint-sequence '(cpintfref dur) *softly*)   ; linked: scale degree x duration
(vp:viewpoint-sequence 'thr-cpint-tactus  *softly*) ; threaded: pitch interval between notes falling on a tactus beat

;; For more information see: https://github.com/mtpearce/idyom/wiki/Viewpoints


;;; ======================================================================================== 
;;; Part D. Running IDyOM

;; Required arguments: 
;; - Dataset ID 
;; - Target viewpoint (e.g., Pitch) 
;; - Source viewpoints (e.g., Pitch interval x Scale Degree or :select = automatically optimised)
;;
;; Optional arguments: 
;; - Configuration: STM, LTM, LTM+, BOTH, BOTH+
;; - Pretraining set for the LTM
;; - Cross-validation parameters (k) 
;; - Detail
;; - Output path
;; 
;; IDyOM outputs information content = - log probability
;; - unpredictability or surpisal
;; - higher values mean more unpredictable, lower values mean more predictable
;; - we prefer models with lower information content, the music is more predictable for them, or in other words, they predict the music more successfully

;; ----------------------------------------------------------------------------------------- 
;; (i) The Short-term model (STM)

;; the simplest model of pitch: the stm learns incrementally through each melody from an initially empty state
(idyom:idyom 19 '(cpitch) '(cpitch) :models :stm)

;; less detailed output for simplicity 
(idyom:idyom 19 '(cpitch) '(cpitch) :models :stm :detail 2)

;; what about using pitch interval as the source viewpoint (cpint)
(idyom:idyom 19 '(cpitch) '(cpint) :models :stm :detail 2)


;; -----------------------------------------------------------------------------------------
;; (ii) The long-term model (LTM)

;; Each melody is predicted by a model trained on the other five melodies
(idyom:idyom 19 '(cpitch) '(cpitch) :models :ltm :k 6 :detail 2)

;; Now we add pre-training on a larger collection of tonal melodies from a close musical culture (91 Alsatian folk songs)
(idyom:idyom 19 '(cpitch) '(cpitch) :models :ltm :k 6 :pretraining-ids '(3) :detail 2)

;; Now lets try pitch interval as a source viewpoint
(idyom:idyom 19 '(cpitch) '(cpint) :models :ltm :k 6 :pretraining-ids '(3) :detail 2)

;; Prediction performance should be worse if trained on a distant musical culture (e.g., 237 Chinese folk songs)
(idyom:idyom 19 '(cpitch) '(cpint) :models :ltm :k 6 :pretraining-ids '(16) :detail 2)

;; -----------------------------------------------------------------------------------------
;; (iii) Combining short- and long-term models 

(idyom:idyom 19 '(cpitch) '(cpint) :models :both :k 6 :pretraining-ids '(3) :detail 2)

(idyom:idyom 19 '(cpitch) '(cpint) :models :ltm+ :k 6 :pretraining-ids '(3) :detail 2)

(idyom:idyom 19 '(cpitch) '(cpint) :models :both+ :k 6 :pretraining-ids '(3) :detail 2)

;; -----------------------------------------------------------------------------------------
;; (iv) Prediction using more than one source viewpoint

(idyom:idyom 19 '(cpitch) '(cpint cpintfref) :models :both+ :k 6 :pretraining-ids '(3) :detail 2)

;; -----------------------------------------------------------------------------------------
;; (v) Prediction using linked viewpoints

(idyom:idyom 19 '(cpitch) '((cpint cpintfref)) :models :both+ :k 6 :pretraining-ids '(3) :detail 2)

(idyom:idyom 19 '(cpitch) '((cpint cpintfref) (cpint dur)) :models :both+ :k 6 :pretraining-ids '(3) :detail 2)

;; -----------------------------------------------------------------------------------------
;; (vi) automatic viewpoint selection
;;
;; :basis :pitch-short --> cpitch cpint contour cpintfref
;; :max-links 2 --> limit linked viewpoints to 2 component viewpoints

(idyom:idyom 19 '(cpitch) :select :models :both+ :k 6 :pretraining-ids '(3) :basis :pitch-short :max-links 2 :detail 2)


;; -----------------------------------------------------------------------------------------
;; (vii) writing output to file

(idyom:idyom 19 '(cpitch) '(cpitch) :models :stm :output-path "~/")


;; -----------------------------------------------------------------------------------------
;; (viii) predicting temporal structure

(vp:viewpoint-sequence 'onset *softly*)

(vp:viewpoint-sequence 'ioi *softly*)

(idyom:idyom 19 '(onset) '(onset) :models :both+ :k 6 :pretraining-ids '(3) :detail 2)

(idyom:idyom 19 '(onset) '(ioi) :models :both+ :k 6 :pretraining-ids '(3) :detail 2)

(idyom:idyom 19 '(onset) '(ioi-ratio) :models :both+ :k 6 :pretraining-ids '(3) :detail 2)

(idyom:idyom 19 '(onset) '(ioi-contour) :models :both+ :k 6 :pretraining-ids '(3) :detail 2)

(idyom:idyom 19 '(onset) '(posinbar) :models :both+ :k 6 :pretraining-ids '(3) :detail 2)

(idyom:idyom 19 '(onset) '((posinbar barlength)) :models :both+ :k 6 :pretraining-ids '(3) :detail 2)

(idyom:idyom 19 '(onset) '((posinbar barlength) ioi-ratio) :models :both+ :k 6 :pretraining-ids '(3) :detail 2)


;; -----------------------------------------------------------------------------------------
;; (ix) predicting pitch and temporal structure

(idyom:idyom 19 '(cpitch onset) '((cpint cpintfref) (posinbar barlength) ioi-ratio) :models :both+ :k 6 :pretraining-ids '(3) :detail 2)


;; -----------------------------------------------------------------------------------------
;; (x) Note that IDyOM is not limited to simple folk songs. Here are
;; some examples from my database (NB: not included in the github
;; repository)

;; 130   Music used in a live experiment conducted by Hauke Egermann & colleagues (pieces for solo flute by Debussy, Varese, Hindemith, Poulenc, Bach)
(dotimes (i 6)
  (print (db:get-description 130 i)))

(idyom:idyom 130 '(cpitch) '(cpitch) :models :stm :detail 2)

;; 135   Cor Anglais solo from Tristan Act 3 
(idyom:idyom 135 '(cpitch) '(cpitch) :models :stm)

;; 170   Unmeasured Prelude No. 7 by Louis Couperin 
(idyom:idyom 170 '(cpitch) '(cpitch) :models :stm)

;; 201   Franz Schubert: Selected songs 
(idyom:idyom 201 '(cpitch) '(cpitch) :models :stm :detail 2)

;; 950   Charlie Parker Real Book.
(idyom:idyom 950 '(cpitch) '(cpitch) :models :stm :detail 2)

;; 2500  Mozart, Rondo for Flute & Piano in D Major. Flute part only
(idyom:idyom 2500 '(cpitch) '(cpitch) :models :stm)


;; -----------------------------------------------------------------------------------------
;; (xi) Predicting harmonic movement 

;; 2020  1 chorale harmonised by J. S. Bach: 4 voices.
(db:preview (db:get-composition 2020 0))

(defvar *chorale* (mo:get-music-objects 2020 0 :texture :harmony))

(mo:preview *chorale*)

(vp:viewpoint-sequence 'h-cpitch *chorale*)
(vp:viewpoint-sequence 'pc-set *chorale*)
(vp:viewpoint-sequence 'pc-set-rel-bass *chorale*)
(vp:viewpoint-sequence 'root-sd *chorale*)

(idyom:idyom 2020 '(h-cpitch) '(root-sd) :models :stm :texture :harmony :detail 2)

;; 2103  Extracts from Mozart's keyboard sonatas: five examples from Sears et al. (2019, QJEP).
;; NB: not included in the github repository
(db:preview (db:get-composition 2103 1))

(idyom:idyom 2103 '(h-cpitch) '(root-sd) :models :stm :texture :harmony :detail 2)
