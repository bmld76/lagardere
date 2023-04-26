;https://www.purebasic.fr/english/viewtopic.php?t=19714
;https://www.purebasic.fr/french/viewtopic.php?t=14753
;https://www.pierre-giraud.com/http-reseau-securite-cours/requete-reponse-session/
Procedure.s SendPost()
  
  Debug SetCurrentDirectory("/Users/bertrand/Mon Drive/PureBasic/Lagardere" )
  Debug "repertoire actuel "+ GetCurrentDirectory()
  
  FullFileName$ = "test.xml" ; Full path+filename, choose your own path
  OpenFile(1,FullFileName$)
  Repeat
    Text$ = ReadString(1)
    FILE$ + Text$ + #CRLF$
  Until Eof(1)
  ;Debug ">"+FILE$ + " >>> "+Len(file$)
  
  
  LenString$=Str(Len(PostData$))
  port.i = 80
  Timeout = 100 ; à ajuster pour assurer un retour complet
                ;server$ = "bmaillard.free.fr"
  server$ = "escrime-info.com"
  QT$=Chr(34)
  
  com$ = "POST /gregxml/Greg/envoyer.php?fichier=./temp/LeHavretest.cotcot&valide=1 HTTP/1.1"+#CRLF$
  com$ + "User-Agent:Lagardere"+#CRLF$
  com$ + "Host: www.escrime-info.com"+#CRLF$
  com$ + "Accept: */*"+#CRLF$
  com$ + "Expect: 100-Continue"+#CRLF$
  ;com$ + "Connection: keep-alive"+#CRLF$
  PostData$ + "Content-Type: multipart/form-data; boundary=--------------------------329524634601592690113207"+#CRLF$
  PostData$ + #CRLF$
  PostData$ + "----------------------------329524634601592690113207"+#CRLF$
  PostData$ + "Content-Disposition: form-Data; name="+QT$+"type_competition"+QT$+#CRLF$
  PostData$ + #CRLF$
  PostData$ + "CompetitionIndividuelle" + #CRLF$
  PostData$ + "----------------------------329524634601592690113207"+#CRLF$
  PostData$ + "Content-Disposition: form-Data; name="+QT$+"indivouequipe"+QT$+ #CRLF$
  PostData$ + #CRLF$
  PostData$ + "indiv"+#CRLF$
  PostData$ + "----------------------------329524634601592690113207"+#CRLF$
  PostData$ + "Content-Disposition: form-Data; name="+QT$+"dp-normal-1"+QT$+ #CRLF$
  PostData$ + #CRLF$
  PostData$ + "26.01.2023"+#CRLF$
  PostData$ + "----------------------------329524634601592690113207"+#CRLF$
  PostData$ + "Content-Disposition: form-Data; name="+QT$+"lieu"+QT$+ #CRLF$
  PostData$ + #CRLF$
  PostData$ + "Le Havre"+#CRLF$
  PostData$ + "----------------------------329524634601592690113207"+#CRLF$
  PostData$ + "Content-Disposition: form-Data; name="+QT$+"niveau"+QT$+ #CRLF$
  PostData$ + #CRLF$
  PostData$ + "L"+#CRLF$
  PostData$ + "----------------------------329524634601592690113207"+#CRLF$
  PostData$ + "Content-Disposition: form-Data; name="+QT$+"Division"+QT$+ #CRLF$
  PostData$ + #CRLF$
  PostData$ + ""+#CRLF$
  PostData$ + "----------------------------329524634601592690113207"+#CRLF$
  PostData$ + "Content-Disposition: form-Data; name="+QT$+"status"+QT$+ #CRLF$
  PostData$ + #CRLF$
  PostData$ + "L"+#CRLF$
  PostData$ + "----------------------------329524634601592690113207"+#CRLF$
  PostData$ + "Content-Disposition: form-Data; name="+QT$+"arme"+QT$+ #CRLF$
  PostData$ + #CRLF$
  PostData$ + "E"+#CRLF$
  PostData$ + "----------------------------329524634601592690113207"+#CRLF$
  PostData$ + "Content-Disposition: form-Data; name="+QT$+"genre"+QT$+ #CRLF$
  PostData$ + #CRLF$
  PostData$ + "H"+#CRLF$ 
  PostData$ + "----------------------------329524634601592690113207"+#CRLF$
  PostData$ + "Content-Disposition: form-Data; name="+QT$+"categorie"+QT$+ #CRLF$
  PostData$ + #CRLF$
  PostData$ + "VET"+#CRLF$ 
  PostData$ + "----------------------------329524634601592690113207"+#CRLF$  
  PostData$ + "Content-Disposition: form-Data; name="+QT$+"submit"+QT$+#CRLF$
  PostData$ + #CRLF$
  ;PostData$ + "send"+#CRLF$
  PostData$ + "Terminer"+#CRLF$
  PostData$ + "----------------------------329524634601592690113207--"+#CRLF$
  
  com$ + "Content-Length:"+Len(PostData$)+#CRLF$ 
  com$ + PostData$
  
  ;Debug  ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"+ Len(com1$)
  
  ConnectionID = OpenNetworkConnection(Server$, port.i,#PB_Network_TCP)
  
  If ConnectionID
    
    ;Res = SendNetworkData(ConnectionID,@com$,Len(com$)) ; pas de HTTP ?
    Res= SendNetworkString(ConnectionID, com$ ,#PB_Ascii) ;  HTTP
    
    Debug ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> début requete méthode POST >>>>>>>>>>>>>>>>>>>>>>"
    Debug com$
    Debug ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Fin de requète >>>>>>>>>>>>>>>>>>>>>>"
    
    Delay(1000)  ; attende de la réponse
    r$ = Space(8000) ; max UDP 65000 évite de gérer un buffer plus petit
    d = ElapsedMilliseconds()
    
    ; lit la reception jusqu'a timeout et retour la réponse
    Repeat
      Result = NetworkClientEvent(ConnectionID)
      If result
        receivLen = ReceiveNetworkData(ConnectionID,@r$,Len(r$))
        If receivLen < 0   ; probleme lors de la connexion 
          ProcedureReturn "Un problème est survenu"
        EndIf
        If receivLen > 0 And receivLen <= Len(r$)
          d = ElapsedMilliseconds()
          buffer$ + PeekS(@r$, receivLen, #PB_UTF8|#PB_ByteLength) ; lecture correcte du retour
        EndIf
      EndIf
      
      Tm = ElapsedMilliseconds()-d
    Until Tm > Timeout  ; garantir fin de transmission
    CloseNetworkConnection(ConnectionID)
    ProcedureReturn buffer$
  EndIf
  
EndProcedure

retour.s = SendPost()
Debug ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  Retour "
Debug retour.s

Resultat = DeleteFile("filetestretour.html")
filesok = OpenFile(1,"filetestretour.html")

Result = WriteString(1, retour.s )
End
If OpenWindow(0,0,0,600,300,"WebGadget",#PB_Window_SystemMenu | #PB_Window_ScreenCentered) 
  WebGadget(0,10,10,580,280,"file:///Users/bertrand/Mon%20Drive/PureBasic/Lagardere/filetestretour.html")
  Repeat 
  Until WaitWindowEvent() = #PB_Event_CloseWindow
EndIf


End
; IDE Options = PureBasic 6.00 LTS (MacOS X - x64)
; CursorPosition = 24
; Folding = -
; EnableXP