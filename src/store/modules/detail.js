import Vue from 'vue'
import axios from 'axios'

/**
 * @author chuzhixin 1204505056@qq.com （不想保留author可删除）
 * @description 代码生成机状态管理
 */
const state = () => ({
  PS_ID: '',
  PS_DanWei: '',
  PS_DanWeiDiZhi: '',
  PS_RenYuan: '',
  PS_Type: '',
  PS_RiQiStart: '',
  PS_RiQiEnd: '',
  PS_RenWuShu: '',
  PS_DanWeiJianJie: '',
  PS_JieLun: '',
  PS_BuHege: '',
  PS_XiangMu: '',
  PS_File: '',
  PS_DanWeiRenYuan: '',
  PS_DanWeiShengChan: '',
  PS_DanWeiJianChe: '',
  PS_Detail: '',
  PIC_XianChang: [],
  PIC_JianCe: [],
  PIC_RenYuan: [],
  PIC_HuiYi: [],
  PIC_YiZhiXing: [],
})
const getters = {
  PS_State: (state) => state,
  PS_ID: (state) => state.PS_ID,
  PS_DanWei: (state) => state.PS_DanWei,
  PS_DanWeiDiZhi: (state) => state.PS_DanWeiDiZhi,
  PS_RenYuan: (state) => state.PS_RenYuan,
  PS_RiQiStart: (state) => state.PS_RiQiStart,
  PS_RiQiEnd: (state) => state.PS_RiQiEnd,
  PS_XiangQing: (state) => state.PS_XiangQing,
  PS_RenWuShu: (state) => state.PS_RenWuShu,
  PS_DanWeiJianJie: (state) => state.PS_DanWeiJianJie,
  PS_JieLun: (state) => state.PS_JieLun,
  PS_BuHege: (state) => state.PS_BuHege,
  PS_File: (state) => state.PS_File,
  PS_DanWeiRenYuan: (state) => state.PS_DanWeiRenYuan,
  PS_DanWeiShengChan: (state) => state.PS_DanWeiShengChan,
  PS_DanWeiJianChe: (state) => state.PS_DanWeiJianChe,
  PS_EditTime: (state) => state.PS_EditTime,
  PIC_YiZhiXing: (state) => state.PIC_YiZhiXing,
  PIC_HuiYi: (state) => state.PIC_HuiYi,
  PIC_RenYuan: (state) => state.PIC_RenYuan,
  PIC_JianCe: (state) => state.PS_AddTime,
  PIC_XianChang: (state) => state.PIC_XianChang,
  PS_XiangMu: (state) => state.PS_XiangMu,
  PS_Type: (state) => state.PS_Type,
}

const mutations = {
  async setPS_ID(state, PS_ID) {
    const _that = this
    console.log('PS_ID')
    console.log(PS_ID)
    let cout = 0
    //const { data, totalCount } = this.queryForm
    // Send a POST request
    let { count, Data } = await axios({
      method: 'post',
      url: 'http://117.160.199.82:7777/anbiao_bg.ashx?type=getRenwu', //请求地址
      data: JSON.stringify({ id: PS_ID }), //表单序列化
    }).then((response) => {
      // Handle response
      console.log('response.data')
      console.log(response.data)
      console.log('response.data')
      return response.data
    })
    state.PS_ID = PS_ID
    state.PS_DanWei = Data[0].PS_DanWei
    state.PS_DanWeiDiZhi = Data[0].PS_DanWeiDiZhi
    state.PS_RenYuan = Data[0].PS_RenYuan
    state.PS_RiQiStart = Data[0].PS_RiQiStart
    state.PS_RiQiEnd = Data[0].PS_RiQiEnd
    state.PS_RenWuShu = Data[0].PS_RenWuShu
    state.PS_DanWeiJianJie = Data[0].PS_DanWeiJianJie
    state.PS_JieLun = Data[0].PS_JieLun
    state.PS_BuHege = Data[0].PS_BuHege
    state.PS_XiangMu = Data[0].PS_XiangMu
    state.PS_File = Data[0].PS_File
    state.PS_DanWeiRenYuan = Data[0].PS_DanWeiRenYuan
    state.PS_DanWeiShengChan = Data[0].PS_DanWeiShengChan
    state.PS_DanWeiJianChe = Data[0].PS_DanWeiJianChe
    state.PS_Detail = Data[0].PS_Detail
    state.PS_Type = Data[0].PS_Type
    console.log('Data[0]')
    console.log(count)
    console.log(Data)
    console.log(state.PS_DanWei)
    console.log('Data[0]')
    //state.PS_DanWei = Data[0].PS_DanWei
  },
  setPS_DanWei(state, PS_DanWei) {
    state.PS_DanWei = PS_DanWei
  },
  setPS_Type(state, PS_Type) {
    state.PS_Type = PS_Type
  },
  setPS_DanWeiDiZhi(state, PS_DanWeiDiZhi) {
    state.PS_DanWeiDiZhi = PS_DanWeiDiZhi
  },
  setPS_RenYuan(state, PS_RenYuan) {
    state.PS_RenYuan = PS_RenYuan
  },
  setPS_RiQiStart(state, PS_RiQiStart) {
    state.PS_RiQiStart = PS_RiQiStart
  },
  setPS_RiQiEnd(state, PS_RiQiEnd) {
    state.PS_RiQiEnd = PS_RiQiEnd
  },
  setPS_XiangQing(state, PS_XiangQing) {
    state.PS_XiangQing = PS_XiangQing
  },
  setPS_RenWuShu(state, PS_RenWuShu) {
    state.PS_RenWuShu = PS_RenWuShu
  },
  setPS_DanWeiJianJie(state, PS_DanWeiJianJie) {
    state.PS_DanWeiJianJie = PS_DanWeiJianJie
  },
  setPS_JieLun(state, PS_JieLun) {
    state.PS_JieLun = PS_JieLun
  },
  setPS_BuHege(state, PS_BuHege) {
    state.PS_BuHege = PS_BuHege
  },
  setPS_File(state, PS_File) {
    state.PS_File = PS_File
  },
  setPS_DanWeiRenYuan(state, PS_DanWeiRenYuan) {
    state.PS_DanWeiRenYuan = PS_DanWeiRenYuan
  },
  setPS_DanWeiShengChan(state, PS_DanWeiShengChan) {
    state.PS_DanWeiShengChan = PS_DanWeiShengChan
  },
  setPS_DanWeiJianChe(state, PS_DanWeiJianChe) {
    state.PS_DanWeiJianChe = PS_DanWeiJianChe
  },
  setPS_XiangMu(state, PS_XiangMu) {
    state.PS_XiangMu = PS_XiangMu
  },
}
const actions = {
  setPS_ID({ commit }, PS_ID) {
    commit('setPS_ID', PS_ID)
  },
  setPS_Type({ commit }, PS_Type) {
    commit('setPS_ID', PS_Type)
  },
  setPS_DanWei({ commit }, PS_DanWei) {
    commit('setPS_DanWei', PS_DanWei)
  },
  setPS_DanWeiDiZhi({ commit }, PS_DanWeiDiZhi) {
    commit('setPS_DanWeiDiZhi', PS_DanWeiDiZhi)
  },
  setPS_RenYuan({ commit }, PS_RenYuan) {
    commit('setPS_RenYuan', PS_RenYuan)
  },
  setPS_RiQiStart({ commit }, PS_RiQiStart) {
    commit('setPS_RiQiStart', PS_RiQiStart)
  },
  setPS_RiQiEnd({ commit }, PS_RiQiEnd) {
    commit('setPS_RiQiEnd', PS_RiQiEnd)
  },
  setPS_XiangQing({ commit }, PS_XiangQing) {
    commit('setPS_XiangQing', PS_XiangQing)
  },
  setPS_RenWuShu({ commit }, PS_RenWuShu) {
    commit('setPS_RenWuShu', PS_RenWuShu)
  },
  setPS_DanWeiJianJie({ commit }, PS_DanWeiJianJie) {
    commit('setPS_DanWeiJianJie', PS_DanWeiJianJie)
  },
  setPS_JieLun({ commit }, PS_JieLun) {
    commit('setPS_JieLun', PS_JieLun)
  },
  setPS_BuHege({ commit }, PS_BuHege) {
    commit('setPS_BuHege', PS_BuHege)
  },
  setPS_File({ commit }, PS_File) {
    commit('setPS_File', PS_File)
  },
  setPS_DanWeiRenYuan({ commit }, PS_DanWeiRenYuan) {
    commit('setPS_DanWeiRenYuan', PS_DanWeiRenYuan)
  },
  setPS_DanWeiShengChan({ commit }, PS_DanWeiShengChan) {
    commit('setPS_DanWeiShengChan', PS_DanWeiShengChan)
  },
  setPS_DanWeiJianChe({ commit }, PS_DanWeiJianChe) {
    commit('setPS_DanWeiJianChe', PS_DanWeiJianChe)
  },
  setPS_XiangMu({ commit }, PS_XiangMu) {
    commit('setPS_XiangMu', PS_XiangMu)
  },
}
export default { state, getters, mutations, actions }
