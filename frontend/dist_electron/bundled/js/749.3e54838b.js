"use strict";(self["webpackChunkmrt_pass"]=self["webpackChunkmrt_pass"]||[]).push([[749],{3749:function(n,e,t){t.r(e),t.d(e,{default:function(){return an}});var u=t(6099),r=t(8361),o=t(3532),a=t(7128),l=t(8811),i=t(5272),c=t(1097),f=t(6778),d=t(3311),s=t(1360),m=t(3239),v=t(7054),p=t(7865),w=t(4029),_=t(7986),h=t(6322),g=t(8401),y=t(6061),U=t(3669),Z=t(2952),W=t(901),S=t(8526),x=t(7360),b=t(3461),k=function(n){return(0,u.dD)("data-v-c5b9fb3a"),n=n(),(0,u.Cn)(),n},C={key:0},P=k((function(){return(0,u._)("div",{m:"x-auto y-6",text:"center secondary"},"查無周遭景點資訊",-1)})),z=[P],I={space:"y-3",m:"t-3 b-20"},V={justify:"items-end",flex:"~",w:"full"},q={flex:"grow",text:"lg title"},H=k((function(){return(0,u._)("div",null,"查看景點",-1)})),j={key:0,flex:"~",justify:"center"},D=["src"],F={style:{"white-space":"pre-line"}},R={key:0,flex:"~",justify:"center items-center",p:"x-4 y-2"},E=k((function(){return(0,u._)("div",null,"編輯",-1)})),N=k((function(){return(0,u._)("div",{m:"1",p:"0.8px",bg:"gray-200"},null,-1)})),Y=k((function(){return(0,u._)("div",null,"刪除",-1)})),M={class:"flex justify-center py-4 px-12"},T={p:"x-4 y-4",bg:"hover:blue-100",text:"seconary hover:blue",border:"rounded-lg 1 gray-200 hover:blue-400"},B={flex:"~",justify:"center"},K={flex:"~ gap-8",class:"justify-center px-12"},A=k((function(){return(0,u._)("div",null,"儲存",-1)})),G=k((function(){return(0,u._)("div",null,"取消",-1)})),J=k((function(){return(0,u._)("div",{text:"sm center secondary",pb:"2"},"請注意，刪除後無法復原",-1)})),L={flex:"~ gap-8",class:"justify-center px-2"},O=k((function(){return(0,u._)("div",null,"刪除",-1)})),Q=k((function(){return(0,u._)("div",null,"取消",-1)})),X={p:"x-4 y-4",bg:"hover:blue-100",text:"seconary hover:blue",border:"rounded-lg 1 gray-200 hover:blue-400"},$={flex:"~",justify:"center"},nn={flex:"~ gap-8",class:"justify-center px-12"},en=k((function(){return(0,u._)("div",null,"儲存",-1)})),tn=k((function(){return(0,u._)("div",null,"取消",-1)})),un=(0,u.aZ)({__name:"MRTcommon",setup:function(n){(0,S.yj)();var e=(0,a.U)(),t=(0,r.iH)({dynamicInputValue:[{CurrentRoute:"",CurrentStation:null}]}),k=(0,r.iH)(!1),P=(0,u.Fl)((function(){var n,e,t,u;return"admin"==(null===(e=null===(n=W.Z.state)||void 0===n?void 0:n.userinfo)||void 0===e?void 0:e.role)||"mrt_admin"==(null===(u=null===(t=W.Z.state)||void 0===t?void 0:t.userinfo)||void 0===u?void 0:u.role)})),un=(0,r.qj)({name:"",context:"",address:"",newtopic:"",newaddress:"",newcontent:""}),rn={topic:[{required:!0,validator:function(n,e){return!!e||new Error("Topic is required")},trigger:["input","blur"]}],address:[{required:!0,validator:function(n,e){return!!e||new Error("Content is required")},trigger:["input","blur"]}]};(0,u.YP)(W.Z.state,(function(){ln()}));var on=(0,r.iH)([]);function an(n){return null==n||null==n.url?null:"http://localhost:3000"+n.url}function ln(){var n;W.Z.state.currentlinestation&&U.Z.get("http://localhost:3000/api/mrt_admin/common",{params:{station_id:null===(n=W.Z.state.currentlinestation)||void 0===n?void 0:n.station.id}}).then((function(n){on.value=n.data.data})).catch((function(n){console.log(n)}))}var cn=(0,r.iH)(),fn=(0,r.iH)(),dn=(0,u.Fl)((function(){var n;return null===(n=cn.value)||void 0===n?void 0:n.map((function(n,e){return{label:n.name,value:n.linecolor}}))})),sn=(0,u.Fl)((function(){var n;return null===(n=fn.value)||void 0===n?void 0:n.map((function(n,e){return n.item.map((function(n,e){return{label:n.station.name,value:n.station.id}}))}))}));function mn(){return{CurrentRoute:"",CurrentStation:null}}function vn(n){U.Z.get("http://localhost:3000/api/mrt_admin/line_station",{params:{linecolor:t.value.dynamicInputValue[n].CurrentRoute}}).then((function(e){fn.value[n].item=e.data.data})).catch((function(n){console.log(n)}))}function pn(){var n=(0,r.iH)(!0);t.value.dynamicInputValue.forEach((function(e,t,u){e.CurrentStation||(n.value=!1)}));var o=(0,r.iH)("");fn.value[0].item.forEach((function(n,e,u){n.station.id==t.value.dynamicInputValue[0].CurrentStation&&(o.value=n.station.name)}));var a=(0,u.Fl)((function(){return t.value.dynamicInputValue[0]?t.value.dynamicInputValue[0].CurrentStation:null})),l=(0,u.Fl)((function(){return t.value.dynamicInputValue[1]?t.value.dynamicInputValue[1].CurrentStation:null})),i=(0,u.Fl)((function(){return t.value.dynamicInputValue[2]?t.value.dynamicInputValue[2].CurrentStation:null}));n.value?(wn.append("name",un.name),wn.append("address",un.address),wn.append("Des",un.context),wn.append("station_id_1",a.value),wn.append("station_id_2",l.value),wn.append("station_id_3",i.value),U.Z.post("http://localhost:3000/api/mrt_admin/common",wn).then((function(n){e.success("新增成功"),ln(),k.value=!1})).catch((function(n){console.log(n)}))):e.error("請填滿空欄或刪除多餘的")}(0,u.wF)((function(){fn=(0,r.iH)([{item:[{linecolor:"",number:0,station:{created_at:"",exit_Num:0,id:0,name:"",updated_at:"",x_Pos:0,y_Pos:0}}]},{item:[{linecolor:"",number:0,station:{created_at:"",exit_Num:0,id:0,name:"",updated_at:"",x_Pos:0,y_Pos:0}}]},{item:[{linecolor:"",number:0,station:{created_at:"",exit_Num:0,id:0,name:"",updated_at:"",x_Pos:0,y_Pos:0}}]}]),U.Z.get("http://localhost:3000/api/mrt_admin/line").then((function(n){cn.value=n.data.data})).catch((function(n){console.log(n)})),ln()}));var wn=new FormData;function _n(n){var e=n.file,t=e.type.includes("image"),u=e.file.size/1024/1024;return t||console.error("上傳內容必須為圖片格式!"),u>2&&console.error("上傳圖片大小不能超過2MB!"),t&&u<2}function hn(n){wn.delete("photo"),0!==n.length&&wn.append("photo",n[0].file,n[0].file.name)}var gn=(0,r.iH)(-1),yn=(0,r.iH)(!1),Un=(0,r.iH)(!1),Zn=(0,r.iH)(-1);function Wn(n){yn.value=!0,gn.value=n}function Sn(){U.Z["delete"]("http://localhost:3000/api/mrt_admin/info/"+gn.value).then((function(n){console.log(n.data.data),yn.value=!1,ln()})).catch((function(n){console.log(n)}))}function xn(n){Un.value=!0,gn.value=n,on.value.forEach((function(n,e){n.info.id==gn.value&&(Zn.value=e)})),un.newtopic=on.value[Zn.value].info.name,un.newaddress=on.value[Zn.value].info.address,un.newcontent=on.value[Zn.value].info.Des}function bn(){wn.append("name",un.newtopic),wn.append("address",un.newaddress),wn.append("Des",un.newcontent),U.Z.patch("http://localhost:3000/api/mrt_admin/common/"+gn.value,wn).then((function(n){e.success("修改成功"),ln(),Un.value=!1})).catch((function(n){console.log(n)}))}function kn(n){console.log(n),Z.Z.push("/Common/"+n.toString())}return function(n,e){var a,U=(0,u.up)("n-upload-dragger");return(0,u.wg)(),(0,u.iD)(u.HY,null,[0==(null===(a=on.value)||void 0===a?void 0:a.length)?((0,u.wg)(),(0,u.iD)("div",C,z)):(0,u.kq)("",!0),(0,u._)("div",I,[((0,u.wg)(!0),(0,u.iD)(u.HY,null,(0,u.Ko)(on.value,(function(n){return(0,u.wg)(),(0,u.j4)((0,r.SU)(l.ZP),{key:null===n||void 0===n?void 0:n.info.id,"footer-style":"padding: 0;",bordered:!1},{header:(0,u.w5)((function(){return[(0,u._)("div",V,[(0,u._)("div",q,(0,o.zw)(n.info.name),1)])]})),"header-extra":(0,u.w5)((function(){return[(0,u.Wm)((0,r.SU)(i.ZP),{onClick:function(e){return kn(n.info.id)},type:"primary",quaternary:""},{icon:(0,u.w5)((function(){return[(0,u.Wm)((0,r.SU)(c.g),{size:18},{default:(0,u.w5)((function(){return[(0,u.Wm)(_.Z)]})),_:1})]})),default:(0,u.w5)((function(){return[H]})),_:2},1032,["onClick"])]})),footer:(0,u.w5)((function(){return[P.value?((0,u.wg)(),(0,u.iD)("div",R,[(0,u.Wm)((0,r.SU)(i.ZP),{onClick:function(e){return xn(n.info.id)},flex:"~ grow",size:"medium",type:"info",quaternary:""},{icon:(0,u.w5)((function(){return[(0,u.Wm)((0,r.SU)(c.g),{size:18},{default:(0,u.w5)((function(){return[(0,u.Wm)(y.Z)]})),_:1})]})),default:(0,u.w5)((function(){return[E]})),_:2},1032,["onClick"]),N,(0,u.Wm)((0,r.SU)(i.ZP),{onClick:function(e){return Wn(n.info.id)},flex:"~ grow",size:"medium",type:"error",quaternary:""},{icon:(0,u.w5)((function(){return[(0,u.Wm)((0,r.SU)(c.g),{size:18},{default:(0,u.w5)((function(){return[(0,u.Wm)(h.Z)]})),_:1})]})),default:(0,u.w5)((function(){return[Y]})),_:2},1032,["onClick"])])):(0,u.kq)("",!0)]})),default:(0,u.w5)((function(){return[null!=an(n.info.photo)?((0,u.wg)(),(0,u.iD)("div",j,[(0,u._)("img",{w:"full",m:"b-4",src:an(n.info.photo)},null,8,D)])):(0,u.kq)("",!0),(0,u._)("div",F,(0,o.zw)(n.info.Des),1)]})),_:2},1024)})),128))]),P.value?((0,u.wg)(),(0,u.j4)((0,r.SU)(l.ZP),{key:1,pos:"fixed bottom-16","footer-style":"padding: 0px;",hoverable:!0},{footer:(0,u.w5)((function(){return[(0,u._)("div",M,[(0,u.Wm)((0,r.SU)(i.ZP),{flex:"~ grow",type:"success",ghost:"",onClick:e[0]||(e[0]=function(n){return k.value=!0})},{icon:(0,u.w5)((function(){return[(0,u.Wm)((0,r.SU)(c.g),{size:18},{default:(0,u.w5)((function(){return[(0,u.Wm)(g.Z)]})),_:1})]})),default:(0,u.w5)((function(){return[(0,u.Uk)(" 新增景點 ")]})),_:1})])]})),_:1})):(0,u.kq)("",!0),(0,u.Wm)((0,r.SU)(f.Z),{show:Un.value,"onUpdate:show":e[5]||(e[5]=function(n){return Un.value=n})},{default:(0,u.w5)((function(){return[(0,u.Wm)((0,r.SU)(l.ZP),{title:"編輯景點資訊","header-style":{"align-self":"center"}},{footer:(0,u.w5)((function(){return[(0,u._)("div",K,[(0,u.Wm)((0,r.SU)(i.ZP),{onClick:bn,type:"primary",flex:"grow",ghost:""},{icon:(0,u.w5)((function(){return[(0,u.Wm)((0,r.SU)(c.g),{size:18},{default:(0,u.w5)((function(){return[(0,u.Wm)(b.Z)]})),_:1})]})),default:(0,u.w5)((function(){return[A]})),_:1}),(0,u.Wm)((0,r.SU)(i.ZP),{onClick:e[4]||(e[4]=function(n){return Un.value=!1}),type:"tertiary",flex:"grow",ghost:""},{icon:(0,u.w5)((function(){return[(0,u.Wm)((0,r.SU)(c.g),{size:18},{default:(0,u.w5)((function(){return[(0,u.Wm)(x.Z)]})),_:1})]})),default:(0,u.w5)((function(){return[G]})),_:1})])]})),default:(0,u.w5)((function(){return[(0,u.Wm)((0,r.SU)(d.Z),{ref:"formRef","label-width":80,model:un,rules:rn,"require-mark-placement":"right-hanging"},{default:(0,u.w5)((function(){return[(0,u.Wm)((0,r.SU)(s.ZP),{label:"景點名字",path:"topic"},{default:(0,u.w5)((function(){return[(0,u.Wm)((0,r.SU)(m.Z),{value:un.newtopic,"onUpdate:value":e[1]||(e[1]=function(n){return un.newtopic=n}),placeholder:"輸入景點名字"},null,8,["value"])]})),_:1}),(0,u.Wm)((0,r.SU)(s.ZP),{label:"地址",path:"topic"},{default:(0,u.w5)((function(){return[(0,u.Wm)((0,r.SU)(m.Z),{value:un.newaddress,"onUpdate:value":e[2]||(e[2]=function(n){return un.newaddress=n}),placeholder:"輸入地址"},null,8,["value"])]})),_:1}),(0,u.Wm)((0,r.SU)(s.ZP),{label:"景點描述",path:"context"},{"header-extra":(0,u.w5)((function(){return[(0,u.Uk)(" 必填 ")]})),default:(0,u.w5)((function(){return[(0,u.Wm)((0,r.SU)(m.Z),{value:un.newcontent,"onUpdate:value":e[3]||(e[3]=function(n){return un.newcontent=n}),type:"textarea",placeholder:"輸入內文"},null,8,["value"])]})),_:1}),(0,u.Wm)((0,r.SU)(s.ZP),{label:"圖片",path:"title"},{default:(0,u.w5)((function(){return[(0,u.Wm)((0,r.SU)(v.Z),{"on-before-upload":_n,"on-update-file-list":hn},{default:(0,u.w5)((function(){return[(0,u.Wm)(U,{w:"full"},{default:(0,u.w5)((function(){return[(0,u._)("div",T,[(0,u._)("div",B,[(0,u.Wm)((0,r.SU)(c.g),{size:"48"},{default:(0,u.w5)((function(){return[(0,u.Wm)(g.Z)]})),_:1})])])]})),_:1})]})),_:1})]})),_:1})]})),_:1},8,["model"])]})),_:1})]})),_:1},8,["show"]),(0,u.Wm)((0,r.SU)(f.Z),{show:yn.value,"onUpdate:show":e[7]||(e[7]=function(n){return yn.value=n})},{default:(0,u.w5)((function(){return[(0,u.Wm)((0,r.SU)(l.ZP),{w:"3/4 min-30",title:"確定要刪除？","header-style":{"align-self":"center"}},{footer:(0,u.w5)((function(){return[(0,u._)("div",L,[(0,u.Wm)((0,r.SU)(i.ZP),{onClick:Sn,type:"error",flex:"grow",ghost:""},{icon:(0,u.w5)((function(){return[(0,u.Wm)((0,r.SU)(c.g),{size:18},{default:(0,u.w5)((function(){return[(0,u.Wm)(h.Z)]})),_:1})]})),default:(0,u.w5)((function(){return[O]})),_:1}),(0,u.Wm)((0,r.SU)(i.ZP),{onClick:e[6]||(e[6]=function(n){return yn.value=!1}),type:"tertiary",flex:"grow",ghost:""},{icon:(0,u.w5)((function(){return[(0,u.Wm)((0,r.SU)(c.g),{size:18},{default:(0,u.w5)((function(){return[(0,u.Wm)(x.Z)]})),_:1})]})),default:(0,u.w5)((function(){return[Q]})),_:1})])]})),default:(0,u.w5)((function(){return[J]})),_:1})]})),_:1},8,["show"]),(0,u.Wm)((0,r.SU)(f.Z),{show:k.value,"onUpdate:show":e[13]||(e[13]=function(n){return k.value=n})},{default:(0,u.w5)((function(){return[(0,u.Wm)((0,r.SU)(l.ZP),{title:"建立景點","header-style":{"align-self":"center"}},{footer:(0,u.w5)((function(){return[(0,u._)("div",nn,[(0,u.Wm)((0,r.SU)(i.ZP),{onClick:pn,type:"primary",flex:"grow",ghost:""},{icon:(0,u.w5)((function(){return[(0,u.Wm)((0,r.SU)(c.g),{size:18},{default:(0,u.w5)((function(){return[(0,u.Wm)(b.Z)]})),_:1})]})),default:(0,u.w5)((function(){return[en]})),_:1}),(0,u.Wm)((0,r.SU)(i.ZP),{onClick:e[12]||(e[12]=function(n){return k.value=!1}),type:"tertiary",flex:"grow",ghost:""},{icon:(0,u.w5)((function(){return[(0,u.Wm)((0,r.SU)(c.g),{size:18},{default:(0,u.w5)((function(){return[(0,u.Wm)(x.Z)]})),_:1})]})),default:(0,u.w5)((function(){return[tn]})),_:1})])]})),default:(0,u.w5)((function(){return[(0,u.Wm)((0,r.SU)(d.Z),{ref:"formRef","label-width":100,model:un,rules:rn,"require-mark-placement":"right-hanging"},{default:(0,u.w5)((function(){return[(0,u.Wm)((0,r.SU)(s.ZP),{label:"景點名稱",path:"topic"},{default:(0,u.w5)((function(){return[(0,u.Wm)((0,r.SU)(m.Z),{value:un.name,"onUpdate:value":e[8]||(e[8]=function(n){return un.name=n}),placeholder:"輸入名稱"},null,8,["value"])]})),_:1}),(0,u.Wm)((0,r.SU)(s.ZP),{label:"附近捷運站"},{default:(0,u.w5)((function(){return[(0,u.Wm)((0,r.SU)(p.Z),{value:t.value.dynamicInputValue,"onUpdate:value":e[9]||(e[9]=function(n){return t.value.dynamicInputValue=n}),placeholder:"请输入","on-create":mn,min:1,max:3},{default:(0,u.w5)((function(n){var e=n.index;n.value;return[(0,u.Wm)((0,r.SU)(w.Z),{value:t.value.dynamicInputValue[e].CurrentRoute,"onUpdate:value":[function(n){return t.value.dynamicInputValue[e].CurrentRoute=n},function(n){return vn(e)}],options:dn.value,placeholder:"請選擇路線"},null,8,["value","onUpdate:value","options"]),(0,u.Wm)((0,r.SU)(w.Z),{value:t.value.dynamicInputValue[e].CurrentStation,"onUpdate:value":function(n){return t.value.dynamicInputValue[e].CurrentStation=n},options:sn.value[e],placeholder:"請選擇站點"},null,8,["value","onUpdate:value","options"])]})),_:1},8,["value"])]})),_:1}),(0,u.Wm)((0,r.SU)(s.ZP),{label:"地址",path:"address"},{"header-extra":(0,u.w5)((function(){return[(0,u.Uk)(" 必填 ")]})),default:(0,u.w5)((function(){return[(0,u.Wm)((0,r.SU)(m.Z),{value:un.address,"onUpdate:value":e[10]||(e[10]=function(n){return un.address=n}),placeholder:"輸入內文"},null,8,["value"])]})),_:1}),(0,u.Wm)((0,r.SU)(s.ZP),{label:"景點描述",path:"context"},{"header-extra":(0,u.w5)((function(){return[(0,u.Uk)(" 必填 ")]})),default:(0,u.w5)((function(){return[(0,u.Wm)((0,r.SU)(m.Z),{value:un.context,"onUpdate:value":e[11]||(e[11]=function(n){return un.context=n}),type:"textarea",placeholder:"輸入內文"},null,8,["value"])]})),_:1}),(0,u.Wm)((0,r.SU)(s.ZP),{label:"圖片",path:"title"},{default:(0,u.w5)((function(){return[(0,u.Wm)((0,r.SU)(v.Z),{"on-before-upload":_n,"on-update-file-list":hn},{default:(0,u.w5)((function(){return[(0,u.Wm)(U,{w:"full"},{default:(0,u.w5)((function(){return[(0,u._)("div",X,[(0,u._)("div",$,[(0,u.Wm)((0,r.SU)(c.g),{size:"48"},{default:(0,u.w5)((function(){return[(0,u.Wm)(g.Z)]})),_:1})])])]})),_:1})]})),_:1})]})),_:1})]})),_:1},8,["model"])]})),_:1})]})),_:1},8,["show"])],64)}}}),rn=t(1725);const on=(0,rn.Z)(un,[["__scopeId","data-v-5722eb99"]]);var an=on}}]);
//# sourceMappingURL=749.3e54838b.js.map