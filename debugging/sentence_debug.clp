 (defglobal ?*str* = (create$ ))

 (load "global_path.clp")
 (load-facts "word.dat")
 (load-facts "parser_type.dat")
 (load-facts "English_sentence.dat")
 (assert (question1 "Input Sentence"))
 (assert (question "Are all the relations correct ::  "))
 (assert (debug_lists))

 (defrule question_ol
 (declare (salience 101))
 ?f<-(question1 ?text)
 (Parser_used Open-Logos-Parser)
 =>
 (retract ?f)
 (system "clear")
 (printout t "START DEBUGGING" crlf)
 (printout t "===============" crlf)
 (system "echo \"Sentence Parsed Using Open-Logos-Parser\" >parser_info")
 (system "echo \"===========================\" >>parser_info")
 (system "cat " ?*home_anu_tmp* " >> parser_info")
 (system "zenity  --title="Sentence-Grammar-information" ---text-info  --filename=parser_info  --width=560  --height=300  &")
 )

 (defrule question
 (declare (salience 101))
 ?f<-(question1 ?text)
 (Parser_used Link-Parser)
 =>
 (retract ?f)
 (system "clear")
 (printout t "START DEBUGGING" crlf)
 (printout t "===============" crlf)
 (system "sed 's/(Eng_sen \"//g' English_sentence.dat |sed  's/\")//g'|sed 's/&quot;/\"/g'|sed 's/\&amp;/&/g' >jnk")
 (system "echo \"Sentence Parsed Using Link-Parser\" >parser_info")
 (system "echo \"=====================\" >>parser_info")
 (system "anu_link-parser.sh <jnk >jnk1 2>err")
 (system "cat " ?*home_anu_tmp* " >> parser_info")
 (system "zenity  --title="Sentence-Grammar-information" ---text-info  --filename=parser_info  --width=560  --height=300  &")
 (system "cat jnk1")
 )

 (defrule question_std
 (declare (salience 101))
 ?f<-(question1 ?text)
 (Parser_used Stanford-Parser)
 =>
 (retract ?f)
 (system "clear")
 (printout t "START DEBUGGING" crlf)
 (printout t "===============" crlf)
 (system "echo \"Sentence Parsed Using Stanford-Parser\" >parser_info")
 (system "echo \"=====================\" >>parser_info")
 (system "echo \"Stanford-Relations\" >>parser_info")
 (system "echo \"----------------------------\" >>parser_info")
 (system "cat sd-relations_tmp1.dat >> parser_info")
 (system "cat " ?*home_anu_tmp* " >> parser_info")
 (system "zenity  --title="Sentence-Grammar-information" ---text-info  --filename=parser_info  --width=560  --height=300  &")
 )

 (defrule choose_debug_list
 (declare (salience 150))
 ?f<-(debug_lists)
 =>
 (retract ?f)
  ; (system "clear")
  (printout t " Please see the two debugging lists given below and choose one, which you feel you are more comfortabe with." crlf)
  (printout t " Next time onwards we'll show you that list only." crlf crlf)
  (printout t "   debug_list-1					   	 debug_list-2" crlf)
  (printout t "   ============ 				   	 ============" crlf)
  (printout t " Enter \"1\" for verb group debugging.		   Enter \"1\" for ting_pada debugging."crlf)
  (printout t " Enter \"2\" for pada debugging.			   Enter \"2\" for sup_pada debugging." crlf)
  (printout t " Enter \"3\" for relations debugging.		   Enter \"3\" for sambandha debugging." crlf)
  (printout t " Enter \"4\" for wsd debugging.			   Enter \"4\" for shabdaartha debugging." crlf)
  (printout t " Enter \"5\" for tam debugging.		   	   Enter \"5\" for kriyaa_pratyaya debugging." crlf)
  (printout t " Enter \"6\" for hindi order debugging.		   Enter \"6\" for Hindi pada krama debugging." crlf)
  (printout t " Enter \"7\" for GNP debugging.			   Enter \"7\" for ling_vachan_purush debugging." crlf)
  (printout t " Enter \"8\" for Verb_agreement debugging.	   Enter \"8\" for abhihita pada nirNaya debugging." crlf)
  (printout t " Enter \"9\" to exit from debugging.	           Enter \"9\" to exit from debugging." crlf crlf)
  (printout t " Enter your choice (\"1\" for debug_list-1  and  \"2\" for debug_list-2) :"  crlf)
  (bind ?read (read))
  (if (eq ?read 1) then
       (assert (question2 "Run debug_list-1"))
  else (if  (eq ?read 2) then
       (assert (question2 "Run debug_list-2"))	
  else
      (assert (debug_lists))
      (printout t "=============================" crlf)
      (printout t "Legal answers are \"(1/2)\" " crlf)))
      (printout t "=============================" crlf)

;   (system "clear")
 )

 (defrule debug_list1
 (declare (salience -10000))
 ?f<-(question2 ?txt)
  =>
  (retract ?f)
  (system "clear")
  (if (eq ?txt "Run debug_list-1") then
  (printout t crlf ?txt crlf)
  (printout t "========================" crlf)
  (printout t " Enter \"1\" for verb group debugging." crlf)
  (printout t " Enter \"2\" for pada debugging." crlf)
  (printout t " Enter \"3\" for relations debugging."crlf)
  (printout t " Enter \"4\" for wsd debugging." crlf)
  (printout t " Enter \"5\" for tam debugging." crlf)
  (printout t " Enter \"6\" for hindi order debugging." crlf)
  (printout t " Enter \"7\" for GNP debugging." crlf)
  (printout t " Enter \"8\" for Verb_agreement debugging." crlf)
  (printout t " Enter \"9\" to exit from debugging." crlf)
  else (if (eq ?txt "Run debug_list-2") then
  (printout t crlf ?txt crlf)
  (printout t "========================" crlf)
  (printout t " Enter \"1\" for ting_pada debugging." crlf)
  (printout t " Enter \"2\" for sup_pada debugging." crlf)
  (printout t " Enter \"3\" for sambandha debugging."crlf)
  (printout t " Enter \"4\" for shabdaartha debugging." crlf)
  (printout t " Enter \"5\" for kriyaa_pratyaya debugging." crlf)
  (printout t " Enter \"6\" for Hindi pada krama debugging." crlf)
  (printout t " Enter \"7\" for ling_vachan_purush debugging." crlf)
  (printout t " Enter \"8\" for abhihita pada nirNaya debugging." crlf)
  (printout t " Enter \"9\" to exit from debugging." crlf)
  ;(printout t " To exit from any of the debugging enter (exit) at the CLIPS prompt." crlf)
  ))
  
  (printout t  crlf " NOTE  ::" crlf)
  (printout t       " ========= "crlf)
  (printout t " i) To terminate the debugging process"crlf)
  ;(printout t "     a) Enter (exit) at the CLIPS prompt.   \"OR\""  crlf)
;  (printout t "     b) Press Ctrl+c and enter (exit) at the CLIPS prompt.(If debugging is in the middle of execution.)"   crlf)
  (printout t "     b) Press Ctrl+c and enter (exit) at the CLIPS prompt."   crlf)
  (printout t " ii) You can also get help information in respective debugging module by entering (Help) command at the clips prompt. (i.e If you are in WSD debugging module, type (Help) at the clips prompt which will show you WSD related information )" crlf)


  (bind ?read (read))
  (if (eq ?read 1) then
      (printout t "LWG_DEBUGGING" crlf)
      (printout t "===============" crlf)
      (bind ?*str* (str-cat "sh $HOME_anu_test/debugging/lwg_debug.sh " ?*file_name* " "  ?*sent_no*))
      (system ?*str*)
      (system "myclips -f run_lwg_debug.bat")
      (assert (question2 ?txt))
 else (if  (eq ?read 2) then
      (printout t "PADA_DEBUGGING" crlf)
      (printout t "===============" crlf)
      (bind ?*str* (str-cat "sh $HOME_anu_test/debugging/pada_debug.sh " ?*file_name* " "  ?*sent_no*))
      (system ?*str*)
      (system "myclips -f run_pada_debug.bat")
      (assert (question2 ?txt))
 else (if  (eq ?read 3) then
      (printout t "RELATIONS_DEBUGGING" crlf) 
      (printout t "===================" crlf)
      (bind ?*str* (str-cat "sh $HOME_anu_test/debugging/relation_debug.sh " ?*file_name* " "  ?*sent_no*))
      (system ?*str*)
      (system "myclips -f run_relation_debug.bat")
      (assert (question2 ?txt))
 else (if  (eq ?read 4) then
      (printout t "WSD_DEBUGGING" crlf)
      (printout t "=============" crlf)
      (bind ?*str* (str-cat "sh $HOME_anu_test/debugging/wsd_debug.sh " ?*file_name* " "  ?*sent_no*))
      (system ?*str*)
      (system "myclips -f run_wsd_debug.bat ")
      (assert (question2 ?txt))
 else (if  (eq ?read 5) then
      (printout t "WSD_TAM_DEBUGGING" crlf)
      (printout t "===============" crlf)
      (bind ?*str* (str-cat "sh $HOME_anu_test/debugging/wsd_tam_debug.sh " ?*file_name* " "  ?*sent_no*))
      (system ?*str*)
      (system "myclips -f run_wsd_tam_debug.bat")
      (assert (question2 ?txt))
 else (if  (eq ?read 6) then
      (printout t "ORDER_DEBUGGING" crlf)
      (printout t "===============" crlf)
      (bind ?*str* (str-cat "sh $HOME_anu_test/debugging/order_debug.sh " ?*file_name* " "  ?*sent_no*))
      (system ?*str*)
      (system "myclips -f run_order_debug.bat")
      (assert (question2 ?txt))
 else (if  (eq ?read 7) then
      (printout t "GNP_DEBUGGING" crlf)
      (printout t "===============" crlf)
      (bind ?*str* (str-cat "sh $HOME_anu_test/debugging/GNP_debug.sh " ?*file_name* " "  ?*sent_no*))
      (system ?*str*)
      (system "myclips -f run_GNP_debug.bat")
      (assert (question2 ?txt))
 else (if  (eq ?read 8) then
      (printout t "VERB_AGREEMENT_DEBUGGING" crlf)
      (printout t "===============" crlf)
      (bind ?*str* (str-cat "sh $HOME_anu_test/debugging/agreement_debug.sh " ?*file_name* " "  ?*sent_no*))
      (system ?*str*)
      (system "myclips -f run_agreement_debug.bat")
      (assert (question2 ?txt))
 else (if  (eq ?read 9) then
      (printout t "EXITING DEBUGGING..........." crlf)
      (printout t "Thank You." crlf)
      (exit)
 else
      (printout t "Enter the correct option" crlf)
      (assert (question2 ?txt))))))))))
  )
 )

