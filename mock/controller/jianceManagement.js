const totalCount = 3
const List = [
  {
    id: '1',
    shebeiname: 'admin',
    xinghao: 'admin',
    jingdu: '@email',
    shuliang: '男',
    zhuangtai: '1985-07',
  },
  {
    id: '3',
    shebeiname: 'admin',
    xinghao: 'admin',
    jingdu: '@email',
    shuliang: '男',
    zhuangtai: '1985-07',
  },
  {
    id: '2',
    shebeiname: 'admin',
    xinghao: 'admin',
    jingdu: '@email',
    shuliang: '男',
    zhuangtai: '1985-07',
  },
]
module.exports = [
  {
    url: '/jianceManagement/getList',
    type: 'post',
    response(config) {
      const { title = '', pageNo = 1, pageSize = 20 } = config.body
      let mockList = List.filter((item) => {
        if (title && item.title.indexOf(title) < 0) return false
        return true
      })
      const pageList = mockList.filter(
        (item, index) =>
          index < pageSize * pageNo && index >= pageSize * (pageNo - 1)
      )
      return {
        code: 200,
        msg: 'success',
        totalCount,
        data: pageList,
      }
    },
  },
  {
    url: '/jianceManagement/doEdit',
    type: 'post',
    response() {
      return {
        code: 200,
        msg: '模拟保存成功',
      }
    },
  },
  {
    url: '/jianceManagement/doDelete',
    type: 'post',
    response() {
      return {
        code: 200,
        msg: '模拟删除成功',
      }
    },
  },
]
