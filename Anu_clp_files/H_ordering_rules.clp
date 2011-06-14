(defglobal ?*order_debug-file* = order_debug)

(deffunction reverse ($?a)
(if (eq (length ?a) 0) then ?a
 else
(create$ (reverse (rest$ ?a)) (first$ ?a))))

(deffunction reverse_daughters ($?a)
(if (< (length ?a) 2) then ?a
 else
(create$ (first$ ?a) (reverse (rest$ ?a)))))
;-----------------------------------------------------------------------------------------------------------------------
(defrule replace_aux_with_head_VP
(declare (salience 1500))
?f<-(Head-Level-Mother-Daughters ?head ?lvl ?Mot ?VB $?daut ?VP)
?f1<-(Head-Level-Mother-Daughters ? ? ?VP $?daut1 ?VP1)
(Node-Category  ?Mot    VP|SQ)
(Node-Category  ?VB     MD|VB|VBN|VBZ|VBD|VBP|VBG)
(Node-Category  ?VP     VP)
(Node-Category  ?VP1    ?CAT)
=>
        (if (eq ?CAT VP) then
        (retract ?f ?f1)
        (assert (Head-Level-Mother-Daughters ?head ?lvl ?Mot $?daut $?daut1 ?VP1))
        else
        (retract ?f)
        (assert (Head-Level-Mother-Daughters ?head ?lvl ?Mot $?daut ?VP))
        )
)
;-----------------------------------------------------------------------------------------------------------------------
(defrule replace_head_VP
(declare (salience 1501))
?f<-(Head-Level-Mother-Daughters ?head ?lvl ?Mot $?daut ?VP)
?f1<-(Head-Level-Mother-Daughters ? ? ?VP ?VP1)
(Node-Category  ?Mot    S)
(Node-Category  ?VP     VP|S)
=>
        (retract ?f ?f1)
        (assert (Head-Level-Mother-Daughters ?head ?lvl ?Mot $?daut ?VP1))
        
)
;-----------------------------------------------------------------------------------------------------------------------
;Added by Shirisha Manju (1-06-11) -- Suggested by Sukhada.
;Failure to comply may result in dismissal.
(defrule dont_rev_if_VP_goesto_TO
(declare (salience 960))
?f0<-(Head-Level-Mother-Daughters  ?head ?lev ?Mot  ?d $?daut)
(Node-Category  ?Mot  VP)
(Node-Category  ?d TO)
(not (Mother  ?Mot))
=>
        (retract ?f0)
        (assert (Head-Level-Mother-Daughters ?head ?lev ?Mot  ?d $?daut))
        (assert (Mother  ?Mot))
	(printout ?*order_debug-file* "rule_name      : dont_rev_if_VP_goesto_TO" crlf "Before reverse : " ?head" " ?lev" "?Mot" "?d" "(implode$  $?daut) crlf)
        (printout ?*order_debug-file* "After reverse  : " ?head" "?lev" " ?Mot" "?d" "(implode$ $?daut) crlf crlf)
)
;-----------------------------------------------------------------------------------------------------------------------
(defrule rev_VP_or_PP_or_WHPP
(declare (salience 950))
?f0<-(Head-Level-Mother-Daughters  ?head ?lev ?Mot  $?daut ?d ?d1 )
(Node-Category  ?Mot  VP|PP|WHPP)
(not (Node-Category  ?d CC));I ate fruits, drank milk and slept. 
(not (Mother  ?Mot))
(not (Daughters_replaced  ?Mot))
(test (and (neq ?head think) (neq ?head thought) (neq ?head thinks) (neq ?head thinking) (neq ?head matter) (neq ?head wonder) (neq ?head say) (neq ?head said) (neq ?head says) (neq ?head saying) (neq ?head disputed) (neq ?head suppose) (neq ?head supposed) (neq ?head supposes) (neq ?head supposing) (neq ?head commented) (neq ?head figured) (neq ?head pointed))) ;Do you think we should go to the party?  He disputed that our program was superior.
=>
	(retract ?f0)
	(bind ?rev_daut (create$ ?head ?lev (reverse_daughters ?Mot $?daut ?d ?d1)))
	(assert (Head-Level-Mother-Daughters ?rev_daut))
	(assert (Mother  ?Mot))
	(printout ?*order_debug-file* "rule_name      : rev_VP_or_PP_or_WHPP " crlf "Before reverse : " ?head" " ?lev" " ?Mot" "  (implode$ $?daut)" " ?d" " ?d1 crlf )
	(printout ?*order_debug-file* "After reverse  : " (implode$ ?rev_daut) crlf crlf)
)
;-----------------------------------------------------------------------------------------------------------------------
; Anne told me I would almost certainly be hired. I showed them how they should do it. I say it is a damn shame that he left. Can you tell us where those strange ideas came from? 
;(defrule rev_VP_SBAR
;(declare (salience 950))
;?f0<-(Head-Level-Mother-Daughters  ?head ?lev ?Mot  $?daut ?v ?NP ?SBAR )
;(Node-Category  ?Mot  VP)
;(Node-Category  ?NP  NP)
;(Node-Category  ?SBAR SBAR)
;=>
;        (retract ?f0)
;        (bind ?rev_daut (create$ ?head ?lev (reverse_daughters ?Mot $?daut ?v ?NP)))
;        (assert (Head-Level-Mother-Daughters ?rev_daut ?SBAR))
;        (assert (Mother  ?Mot))
;	(printout ?*order_debug-file* "rule_name      : rev_VP_SBAR " crlf "Before reverse : " ?head" " ?lev" " ?Mot" "  (implode$ $?daut)" " ?v" " ?NP" "?SBAR crlf )
;        (printout ?*order_debug-file* "After reverse  : " (implode$ ?rev_daut)" " ?SBAR crlf)
;)
;-----------------------------------------------------------------------------------------------------------------------
; Added by Shirisha Manju(30-05-11) Suggested by Sukhada. Modified by Sukhada on 31-05-11.
;Buying of shares was brisk on Wall Street today. She is very careful about her work.  
(defrule rev_ADJP_goesto_PP
(declare (salience 950))
?f0<-(Head-Level-Mother-Daughters  ?head ?lev ?Mot  $?daut ?d)
(Node-Category  ?Mot  ADJP)
(Node-Category  ?d  PP|S);Dick is important to fix the problem.
(not (Mother  ?Mot))
=>
        (retract ?f0)
        (assert (Head-Level-Mother-Daughters   ?head ?lev ?Mot ?d $?daut))
        (assert (Mother  ?Mot))
  	(printout ?*order_debug-file* "rule_name      : rev_ADJP_goesto_PP " crlf "Before reverse : " ?head" " ?lev" " ?Mot" "(implode$ $?daut)" "?d crlf )
        (printout ?*order_debug-file* "After reverse   : "?head" " ?lev" " ?Mot" "?d" "(implode$ $?daut) crlf crlf)
)
;-----------------------------------------------------------------------------------------------------------------------
;Added by Shirisha Manju(14-06-11) -- suggested by sukhada
;The yield of kharif crops was not good this season.
(defrule rev_ADJP_goesto_RB
(declare (salience 900))
?f0<-(Head-Level-Mother-Daughters  ?head ?lev ?Mot  $?daut ?d $?dt)
(Head-Level-Mother-Daughters ? ? ?d ?id)
(Node-Category  ?Mot  ADJP)
(Node-Category  ?d  RB)
(id-word ?id not)
(not (Mother  ?Mot))
=>
        (retract ?f0)
        (assert (Head-Level-Mother-Daughters   ?head ?lev ?Mot $?daut $?dt ?d))
        (assert (Mother  ?Mot))
        (printout ?*order_debug-file* "rule_name      : rev_ADJP_goesto_RB " crlf "Before reverse : " ?head" " ?lev" " ?Mot" "(implode$ $?daut)" "?d " "(implode$ $?dt) crlf )
        (printout ?*order_debug-file* "After reverse  : "?head" " ?lev" " ?Mot" "(implode$ $?daut) " "(implode$ $?dt) " " ?d crlf crlf)
)
;-----------------------------------------------------------------------------------------------------------------------
; Added by Shirisha Manju(27-05-11) Suggested by Sukhada
; Is there life beyond the grave? Is this my book? 
; Is my book in your room? Are you reading the book?
(defrule move_first_child_of_SQ_last
(declare (salience 950))
?f0<-(Head-Level-Mother-Daughters  ?head ?lev ?Mot  ?d $?daut)
(Node-Category  ?Mot  SQ)
(Node-Category  ?d  MD|VB|VBN|VBZ|VBD|VBP|VBG)
(not (Mother  ?Mot))
=>
        (retract ?f0)
        (assert (Head-Level-Mother-Daughters ?head ?lev ?Mot $?daut ?d))
        (assert (Mother  ?Mot))
	(printout ?*order_debug-file* "rule_name      : move_first_child_of_SQ_last " crlf "Before reverse : " ?head" " ?lev" " ?Mot" "?d" " (implode$ $?daut) crlf )
        (printout ?*order_debug-file* "After reverse  : "?head" " ?lev" " ?Mot" "(implode$  $?daut)" " ?d crlf crlf)
)
;-----------------------------------------------------------------------------------------------------------------------
; Added by Shirisha Manju(28-05-11) Suggested by Sukhada
;This is the way to go. 
(defrule move_S_last_child_first
(declare (salience 950))
?f0<-(Head-Level-Mother-Daughters  ?head ?lev ?Mot  $?daut ?d)
(Node-Category  ?Mot  NP)
(Node-Category  ?d S)
(not (Mother  ?Mot))
=>
        (retract ?f0)
        (assert (Head-Level-Mother-Daughters ?head ?lev ?Mot ?d $?daut))
        (assert (Mother  ?Mot))
	(printout ?*order_debug-file* "rule_name      : move_S_last_child_first " crlf "Before reverse : " ?head" " ?lev" " ?Mot" "  (implode$ $?daut)" " ?d crlf )
        (printout ?*order_debug-file* "After reverse  : " ?head" " ?lev" "?Mot" " ?d" "(implode$  $?daut)  crlf crlf)
)
;-----------------------------------------------------------------------------------------------------------------------
;The;Assumptions while writing this rule:
;If the daughters of the NP are not numbers then only this rule fires.
;These are given assuming that if first daughter of the Mother-NP is NP the rest daughters will never be numbers
(defrule reverse-NP-Daughters
(declare (salience 800))
?f0<-(Head-Level-Mother-Daughters ?head ?lvl ?mot ?NP ?PP)
(Node-Category  ?mot  NP)
(Node-Category  ?NP  NP)
(Node-Category  ?PP PP|SBAR)
(not (Mother  ?mot))
=>
	(retract ?f0)
	(bind ?NP_rev (create$ ?head ?lvl (reverse_daughters ?mot ?NP ?PP)))
	(assert (Head-Level-Mother-Daughters ?NP_rev))
	(assert (Mother  ?mot))
	(printout ?*order_debug-file* "rule_name      : reverse-NP-Daughters " crlf "Before reverse : " ?head" " ?lvl" " ?mot" " ?NP" " ?PP crlf )
	(printout ?*order_debug-file* "After reverse  : " (implode$ ?NP_rev) crlf crlf)
)
;-----------------------------------------------------------------------------------------------------------------------
;All our sisters are coming. He left all his money to the orphanage. 
(defrule replace_NP-daut_PDT
(declare (salience 800))
?f0<-(Head-Level-Mother-Daughters ?head ?lvl ?mot ?PDT ?PRP ?N )
(Node-Category  ?mot  NP)
(Node-Category  ?PDT  PDT)
(not (Mother  ?mot))
=>
        (retract ?f0)
        (assert (Head-Level-Mother-Daughters ?head ?lvl ?mot ?PRP  ?PDT ?N ))
        (assert (Mother  ?mot))
	(printout ?*order_debug-file* "rule_name      : replace_NP-daut_PDT " crlf "Before replace : " ?head" " ?lvl" " ?mot" " ?PDT" " ?PRP" " ?N crlf )
        (printout ?*order_debug-file* "After replace   : " ?head" " ?lvl" " ?mot" " ?PRP" "?PDT" " ?N crlf crlf)
)
;-----------------------------------------------------------------------------------------------------------------------
;Here we undef all the rules (As this rule are firing again after the nodes are replaced with terminal)
(defrule undefrules
(declare (salience 799))
=>
(undefrule replace_aux_with_head_VP)
(undefrule replace_head_VP)
(undefrule dont_rev_if_VP_goesto_TO)
(undefrule rev_VP_or_PP_or_WHPP)
(undefrule rev_ADJP_SBAR)
(undefrule rev_ADJP_goesto_PP)
(undefrule move_first_child_of_SQ_last)
(undefrule move_S_last_child_first)
(undefrule reverse-NP-Daughters)
(undefrule replace_NP-daut_PDT))
;-----------------------------------------------------------------------------------------------------------------------
;
(defrule get_SBAR
(declare (salience 798))
?f<-(Head-Level-Mother-Daughters ?head ?lvl ?Mot $?pre ?dat $?pos)
(Head-Level-Mother-Daughters ? ? ?dat $?child)
(Node-Category  ?Mot SBAR|SBARQ)
(Node-Category  ?dat ?DAT)
=>
(retract ?f)
(if (or (eq ?DAT SBAR)(eq ?DAT SBARQ)) then
(assert (Head-Level-Mother-Daughters ?head ?lvl ?Mot $?pre $?pos))
else
(assert (Head-Level-Mother-Daughters ?head ?lvl ?Mot $?pre $?child $?pos)))
)
;-----------------------------------------------------------------------------------------------------------------------
(defrule msg_replace_dau
(declare (salience 750))
 =>
	(printout ?*order_debug-file* "Substituting Mother Node with Child Node "crlf)
	(printout ?*order_debug-file* "==========================================" crlf)
)
;-----------------------------------------------------------------------------------------------------------------------
(defrule replace-daughters
(declare (salience 700))
?used1<-(Head-Level-Mother-Daughters ?head ? ?mother $?daughters)
?used2<-(Head-Level-Mother-Daughters ?head1 ?level ?mother1 $?pre ?mother $?post)
(not (replaced_daughters ?mother))
=>
	(retract  ?used2)
	(assert (Head-Level-Mother-Daughters ?head1 ?level ?mother1 $?pre $?daughters $?post))
	(assert (replaced_daughters ?mother))
	(printout ?*order_debug-file* "rule_name : replace-daughters  " ?mother1 $?pre $?daughters $?post crlf)
)
;-----------------------------------------------------------------------------------------------------------------------
;This rule delete's all the SBAR from ROOT
(defrule rmv_sbar_from_root
(declare (salience -80))
?f<-(Head-Level-Mother-Daughters ?head ?lvl ?Mot $?daut)
?f1<-(Head-Level-Mother-Daughters ? ? ?dat $?child)
(Node-Category  ?Mot ROOT)
(Node-Category  ?dat SBAR|SBARQ)
(test (member$ $?child $?daut))
=>
(retract ?f)
 (assert (Sen  $?child))
 (loop-for-count (?i 1 (length $?child))
                 (bind ?id (nth$ ?i $?child))
                 (bind $?daut (delete-member$ $?daut ?id)))
 (assert (Head-Level-Mother-Daughters ?head ?lvl ?Mot $?daut)))
;-----------------------------------------------------------------------------------------------------------------------
;The Master said, if I did not go, how would you ever see? 
(defrule create_sen
(declare (salience -90))
?f1<-(Head-Level-Mother-Daughters ? ? ?dat $?child)
(Node-Category  ?dat SBAR|SBARQ)
(not (sent $?child))
=>
(assert (Sen  $?child))
(assert (sen  $?child))
)
;-----------------------------------------------------------------------------------------------------------------------
;Here ROOT category is changed to SBAR
(defrule rename_ROOT_cat_to_SBAR
(declare (salience -99))
?f<-(Head-Level-Mother-Daughters ?head ?lvl ?Mot $?daut)
?f1<-(Node-Category  ?Mot ROOT)
=>
(retract ?f1)
(assert (Sen $?daut))
(assert (Node-Category  ?Mot SBAR))
(assert (hindi_id_order))
)
;-----------------------------------------------------------------------------------------------------------------------
(defrule hin_order
(declare (salience -100))
?f0<-(Sen $?daughters ?id)
(not (Sen $? ?id1&:(> ?id ?id1)))
?f1<-(hindi_id_order $?dau)
;(test (eq (member$ ?id $?dau) FALSE))
=>
	(retract ?f0 ?f1)
	(assert (hindi_id_order $?dau $?daughters ?id))
	(printout ?*order_debug-file* crlf "rule name   : hin_order  " crlf "Final order : " (implode$ $?daughters) crlf)
)
;-----------------------------------------------------------------------------------------------------------------------
;The girl you met yesterday is here. The dog I chased was black.
(defrule insert_jo_samAnAXikaraNa
(declare (salience 4))
?f0<-(hindi_id_order $?id ?sub $?id1 ?k $?daut)
(or (kriyA-object  ?k  10000)(kriyA-aXikaraNavAcI_avyaya  ?k  10000))
(kriyA-subject  ?k ?sub)
(viSeRya-jo_samAnAXikaraNa  ?  10000)
(not (jo_samAn_id_inserted ))
=>
        (retract ?f0)
        (assert (hindi_id_order $?id 10000 ?sub $?id1 ?k $?daut))
        (assert (jo_samAn_id_inserted ))
        (printout ?*order_debug-file* "rule_name      : insert_jo_samAnAXikaraNa " crlf "Before insertion : " $?id" " ?sub" " $?id1" " ?k" " $?daut crlf)
        (printout ?*order_debug-file* "After insertion  : "  $?id"  10000 "?sub" " $?id1" " ?k" " $?daut crlf crlf)
)
;-----------------------------------------------------------------------------------------------------------------------
;Our team was easily beaten in the competition.
(defrule move_kri_vi_be4_kri
(declare (salience 4))
?f<-(hindi_id_order  $?pre ?kri $?po ?k_vi $?last)
(kriyA-kriyA_viSeRaNa  ?kri ?k_vi) 
=>
	(retract ?f)
        (assert (hindi_id_order $?pre ?k_vi ?kri $?po $?last))
	(printout ?*order_debug-file* "rule_name      : move_kri_vi_be4_kri " crlf "Before Movement : "$?pre" " ?kri" " $?po" " ?k_vi" " $?last crlf) 
	(printout ?*order_debug-file* "After movement  : " $?pre" " ?k_vi" " ?kri" " $?po" " $?last crlf crlf)
)
;-----------------------------------------------------------------------------------------------------------------------
;Have you ever seen the Pacific? 
(defrule move_kri_vi_be4_obj
(declare (salience 5))
?f<-(hindi_id_order  $?pre ?obj $?po ?k_vi ?kri $?last)
(kriyA-kriyA_viSeRaNa  ?kri ?k_vi)
(kriyA-object  ?kri ?obj)
=>
        (retract ?f)
        (assert (hindi_id_order $?pre ?k_vi  ?obj $?po ?kri $?last))
	(printout ?*order_debug-file* "rule_name      : move_kri_vi_be4_obj " crlf "Before Movement : "$?pre" " ?obj" " $?po" " ?k_vi" "?kri" " $?last crlf)
        (printout ?*order_debug-file* "After movement  : " $?pre" " ?k_vi" "  ?obj" " $?po" " ?kri" " $?last crlf crlf)
)
;-----------------------------------------------------------------------------------------------------------------------
(defrule end_order
(declare (salience -200))
=>
	(close ?*order_debug-file*)
)
;-----------------------------------------------------------------------------------------------------------------------