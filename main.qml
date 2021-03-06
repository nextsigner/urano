import QtQuick 2.7
import QtQuick.Controls 2.0
import QtWebEngine 1.4

ApplicationWindow {
    id:app
    visible: true
    width: 1400
    height: 600
    visibility:"Maximized"
    title: 'urano'
    property string tool: ""
    onToolChanged: {
        if(app.tool === "quickcode"){
            xQuickCode.state = "show"
        }else{
            xQuickCode.state = "hide"
        }
    }
    FontLoader {name: "FontAwesome";source: "qrc:/fontawesome-webfont.ttf";}

    WebEngineView{
        id: wv
        width: app.width-xTools.width
        height: app.height
        anchors.left: xTools.right
        url: 'https://writer.bighugelabs.com/'
        profile: defaultProfile
        property QtObject defaultProfile: WebEngineProfile {
            storageName: "Default"

            onDownloadRequested: {
                download.path=uk.getPath(2)+'/main.qml'
                download.accept();
                console.log(download.path)
            }
            onDownloadFinished: {
                var d=''+uk.getFile(uk.getPath(2)+'/main.qml', true)
                console.log('--------->'+d)
                var m0=d.split('\n')
                var l1 = ''+m0[0]
                var fileName = l1.substring(2,l1.length)
                console.log('Saving: '+fileName)
                var m1 = fileName.split('/')


                var folder = fileName.replace('/'+m1[m1.length-1], '')
                var l2 = ''+m0[1]
                //var cl = l2.substring(2,l2.length)
                uk.mkdir(folder)
                uk.setFile(fileName,d,true)
                var cl = '-folder '+folder

                var appPath
                if(Qt.platform.os==='windows'){
                    appPath = '"'+uk.getPath(1)+'/'+uk.getPath(0)+'"'
                    uk.setFile('H:/cl.txt',cl,true)
                }
                if(Qt.platform.os==='linux'){
                    //appPath = '"'+uk.getPath(1)+'/'+uk.getPath(0)+'"'
                    //appPath = '"'+uk.getPath(1)+'/'+uk.getPath(0)+'"'
                    appPath = '"'+appExec+'"'
                }
                //uk.setFile('H:/cl.txt', appPath+' '+cl,true)
                //uk.setFile('/home/nextsigner/Escritorio/fn.txt', fileName,true)
                //uk.setFile('/home/nextsigner/Escritorio/cl.txt', appPath+' '+cl,true)
                console.log('Running: '+appPath+' '+cl)
                uk.run(appPath+' '+cl, true)
            }
        }
        settings.javascriptCanOpenWindows: true
        settings.allowRunningInsecureContent: false
        //settings.hyperlinkAuditingEnabled:  true
        settings.javascriptCanAccessClipboard: true
        settings.localStorageEnabled: true
        settings.javascriptEnabled: true
        onNewViewRequested: {
            request.openIn(wv)
            request.accepted = true;
        }

        onContextMenuRequested: function(request) {
            request.accepted = true;
            contextMenu.x = request.x;
            contextMenu.y = request.y;
            
            contextMenu.visible = true
            
        }

    }
    Menu {
        id: contextMenu
        MenuItem { text: "Guardar C??digo"
            onTriggered:{
                    wv.triggerWebAction(WebEngineView.Copy)
                    guardarCodigo.visible = true
            }
        }
        MenuItem { text: "Atras"
            onTriggered:{
                wv.goBack()
            }
        }
        MenuItem { text: "Adelante"
            onTriggered:{
                wv.goForward()
            }
        }
        MenuItem { text: "Cortar"
            onTriggered:{
                wv.triggerWebAction(WebEngineView.Cut)
            }
        }
        MenuItem { text: "Copiar"
            onTriggered:{
                wv.triggerWebAction(WebEngineView.Copy)
                var js='\'\'+window.getSelection()'
                wv.runJavaScript(js, function(result) {
                    console.log(result);
                });

                //console.log(wv.ViewSource.toString())
            }
        }
        MenuItem {
            text: "Pegar"
            onTriggered:{
                wv.triggerWebAction(WebEngineView.Paste)
            }
        }
    }

    Rectangle{
        id: xTools
        width: app.width*0.02
        height: app.height
        color: "#000"
        border.width: 1
        border.color: "white"
        Column{
            width: parent.width
            spacing:  width*0.5
            anchors.verticalCenter: parent.verticalCenter


            Boton{
                w:parent.width
                h: w
                t: "\uf04b"
                onClicking: {
                    wv.runJavaScript('chooseExport(\'txt\', \'Download text file\'); exportDoc();', function(result) { console.log(result); })
                    //app.tool === "quickcode" ? "" : "quickcode"
                }
            }
            Boton{
                w:parent.width
                h: w
                t: "\uf121"
                onClicking: {
                    app.tool = app.tool === "quickcode" ? "" : "quickcode"
                }
            }
            Boton{
                w:parent.width
                h: w
                t: "\uf011"
                onClicking: {
                    Qt.quit()
                }
            }
        }
    }

    Rectangle{
        id: xQuickCode
        width: app.width*0.2
        height: app.height
        color: "#333"
        border.width: 1
        border.color: "white"
        state: app.tool === "quickcode" ? "show" : "hide"
        states:  [
            State {
                name: "hide"
                PropertyChanges {
                    target: xQuickCode
                    x: 0-xQuickCode.width
                }
            },
            State {
                name: "show"
                PropertyChanges {
                    target: xQuickCode
                    x: 0
                }
            }

        ]
        transitions: [
            Transition {
                from: "hide"
                to: "show"
                NumberAnimation { properties: "x"; easing.type: Easing.InOutQuad; duration: 500 }
            },
            Transition {
                from: "show"
                to: "hide"
                NumberAnimation { properties: "x"; easing.type: Easing.InOutQuad; duration: 250 }
            }
        ]
        Column{
            anchors.fill: parent
            Text {
                id: txtTitQC
                text: "QuickCode"
                font.pixelSize: app.width*0.01
                anchors.horizontalCenter: parent.horizontalCenter
                color: "white"
            }
            Rectangle{
                id: xSearch
                width: parent.width
                height: txtTitQC.contentHeight*1.4
                color: "#ccc"
                TextInput{
                    id: tiSearch
                    width: parent.width*0.98-btnSearch.w
                    height: parent.height*0.98
                    anchors.centerIn: parent
                    font.pixelSize: parent.height*0.9
                    text: "search"
                    anchors.left: parent.left
                    anchors.leftMargin: parent.height*0.02
                    onFocusChanged: {
                        selectAll()
                    }
                    onTextChanged: {
                            loadQC(text)
                    }
                }
                Boton{
                    id: btnSearch
                    w:parent.height*0.9
                    h: w
                    t: "\uf002"
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    onClicking: {
                        loadQC(tiSearch.text)
                    }
                }
            }
            Rectangle{
                width: parent.width
                height: parent.height-txtTitQC.contentHeight-xSearch.height
                color: "#ccc"
                border.width: 1
                border.color: "white"

                ListView{
                    id:listQC
                    width: parent.width*0.98
                    height: parent.height
                    anchors.centerIn: parent
                    clip: true
                    model: lmQC
                    delegate: delQC
                    spacing: 10
                    ListModel{
                        id: lmQC
                        function add(i, n, c, rc){
                            return {
                                cid: i,
                                nom: n,
                                code: c,
                                rcode: rc
                            }
                        }
                    }
                    Component{
                        id: delQC
                        Rectangle{
                            width: parent.width
                            height: labelNomQC.height+labelCodeQC.height
                            property string realCode: rcode
                            Text{
                                id: labelNomQC
                                text: nom+'\n'
                                font.pixelSize: parent.width*0.05
                                wrapMode: Text.WordWrap
                            }
                            Text{
                                id: labelCodeQC
                                text: code
                                font.pixelSize: parent.width*0.025
                                width: parent.width*0.98
                                anchors.horizontalCenter: parent.horizontalCenter
                                //textFormat: Text.RichText
                                wrapMode: Text.WordWrap
                                anchors.top: labelNomQC.bottom
                            }
                            MouseArea{
                                anchors.fill: parent
                                onClicked: {
                                    clipboard.setText(rcode)
                                    wv.triggerWebAction(WebEngineView.Paste)
                                }
                            }
                            Boton{
                                w:parent.width*0.04
                                h: w
                                t: "X"
                                anchors.right: parent.right
                                onClicking: {
                                    var sql = 'DELETE FROM quickcodes WHERE id='+cid
                                    unik.sqlQuery(sql, true)
                                    loadQC("")
                                }
                            }
                        }

                    }

                }

            }
        }
        Boton{
            w: txtTitQC.height
            h: w
            t:"X"
            anchors.right: parent.right
            onClicking: app.tool = ""
        }
    }

    GuardarCodigo{
        id: guardarCodigo
        visible:false
        onGuardandoComo: {
            var txt = ''+clipboard.getText();
            var  sql = 'INSERT INTO quickcodes(id, nom, qc)VALUES(NULL, \''+n+'\', \''+txt+'\')'
            uk.sqlQuery(sql, true)
            loadQC("")
            console.log(txt)
        }
    }
    Component.onCompleted:  {
        var sf = ((''+appsDir).replace('file:///', ''))+'/unik-writer.sqlite'
        var initSqlite = uk.sqliteInit(sf, true)
        var sql

        //Tabla quickcodes
        sql = 'CREATE TABLE IF NOT EXISTS quickcodes(
                       id INTEGER PRIMARY KEY AUTOINCREMENT,
                       nom TEXT,
                       qc NUMERIC
                        )'
        uk.sqlQuery(sql, true)
        loadQC("")
    }

    function sinSalto(t){
        var c = ''+t
        var c2 = c.replace(/\\n/g, '\x0A')
        return c2
    }
    function conSalto(t){
        var c = ''+t
        var c2 = c.replace(/\\x0A/g, '\n')
        return c2
    }

    function getVG(nom, valxdef){
        var sql = 'select val from varglob where nom=\''+nom+'\''
        var res = uk.getJsonSql('varglob', sql, 'sqlite', true)
        var json = JSON.parse(res)
        if(json['row0']!==undefined){
            return json['row0'].col0
        }else{
            sql = 'INSERT INTO varglob(id, nom, val)VALUES(NULL, \''+nom+'\', \''+valxdef+'\')'
            uk.sqlQuery(sql, true)
        }
        return ''
    }
    function loadQC(s){
        lmQC.clear()
        var sql = 'select * from quickcodes where nom like \'%'+s+'%\' or qc like \'%'+s+'%\''
        var res = ''+uk.getJsonSql('quickcodes', sql, 'sqlite', true)
        var res2 = res.replace(/\n/g, '<br />')
        var res3 = res2.replace(/\t/g, '&#09;')

        var json = JSON.parse(res3)
        for(var i=0; i < Object.keys(json).length; i++){
            var item = Object.keys(json)[i]
            var code = ''+json['row'+i].col2
            var rcode = ''+json['row'+i].col2
            var rcode1 = rcode.replace(/<br \/>/g, '\n')
            var rcode2 = rcode1.replace(/&#09;/g, '\t')
            var code1 = code.replace(/<br \/>/g, '<br>')
            var code2 = code1.replace(/&#09;/g, '--')
            lmQC.append(lmQC.add(json['row'+i].col0, json['row'+i].col1, code2, rcode2))
        }
    }
}
