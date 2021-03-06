
(defrule affront0
(declare (salience 5000))
(id-root ?id affront)
?mng <-(meaning_to_be_decided ?id)
(id-word ?id affronted )
(id-cat_coarse ?id adjective)
=>
(retract ?mng)
(assert (id-wsd_word_mng ?id apamAniwa))
(if ?*debug_flag* then
(printout wsd_fp "(dir_name-file_name-rule_name-id-wsd_word_mng  " ?*wsd_dir* "  affront.clp  	affront0   "  ?id "  apamAniwa )" crlf))
)

;"affronted","Adj","1.apamAniwa"
;I was very much affronted by your rudeness.
;
(defrule affront1
(declare (salience 4900))
(id-root ?id affront)
?mng <-(meaning_to_be_decided ?id)
(id-cat_coarse ?id noun)
=>
(retract ?mng)
(assert (id-wsd_root_mng ?id apamAna))
(if ?*debug_flag* then
(printout wsd_fp "(dir_name-file_name-rule_name-id-wsd_root_mng   " ?*wsd_dir* "  affront.clp 	affront1   "  ?id "  apamAna )" crlf))
)

;"affront","N","1.apamAna"
;His word were an affront to all the members of the union.
;
(defrule affront2
(declare (salience 4800))
(id-root ?id affront)
?mng <-(meaning_to_be_decided ?id)
(id-cat_coarse ?id verb)
=>
(retract ?mng)
(assert (id-wsd_root_mng ?id apamAniwa_kara))
(if ?*debug_flag* then
(printout wsd_fp "(dir_name-file_name-rule_name-id-wsd_root_mng   " ?*wsd_dir* "  affront.clp 	affront2   "  ?id "  apamAniwa_kara )" crlf))
)

;"affront","V","1.apamAniwa_karanA"
;How dare you affront me.
;
