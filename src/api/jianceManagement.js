import request from '@/utils/request'

export function getList(data) {
  return request({
    url: '/jianceManagement/getList',
    method: 'post',
    data,
  })
}

export function doEdit(data) {
  return request({
    url: '/jianceManagement/doEdit',
    method: 'post',
    data,
  })
}

export function doDelete(data) {
  return request({
    url: '/jianceManagement/doDelete',
    method: 'post',
    data,
  })
}
