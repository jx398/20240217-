const totalCount = 3
const List = [
  {
    id: '1',
    username: 'admin',
    password: 'admin',
    email: '@email',
    xingbie: '男',
    birthday: '1985-07',
    xueli: '大专',
    zhuanyie: '机械设计',
    zhicheng: '工程师',
    zhiwu: '总经理',
    phone: '037168091801',
    tel: '13838101735',
    permissions: ['admin'],
    datatime: '@datetime',
  },
  {
    id: '2',
    username: 'editor',
    password: 'editor',
    email: '@email',
    permissions: ['editor'],
    datatime: '@datetime',
    xingbie: '男',
    birthday: '1985-07',
    xueli: '大专',
    zhuanyie: '机械设计',
    zhicheng: '工程师',
    zhiwu: '总经理',
    phone: '037168091801',
    tel: '13838101735',
  },
  {
    id: '3',
    username: 'test',
    password: 'test',
    email: '@email',
    permissions: ['admin', 'editor'],
    datatime: '@datetime',
    xingbie: '男',
    birthday: '1985-07',
    xueli: '大专',
    zhuanyie: '机械设计',
    zhicheng: '工程师',
    zhiwu: '总经理',
    phone: '037168091801',
    tel: '13838101735',
  },
]
module.exports = [
  {
    url: '/userManagement/getList',
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
    url: '/userManagement/doEdit',
    type: 'post',
    response() {
      return {
        code: 200,
        msg: '模拟保存成功',
      }
    },
  },
  {
    url: '/userManagement/doDelete',
    type: 'post',
    response() {
      return {
        code: 200,
        msg: '模拟删除成功',
      }
    },
  },
]
