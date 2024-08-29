import request from '@/utils/request'

export function getList(data) {
  return request({
    url: '/shebeiManagement/getList',
    method: 'post',
    data,
  })
}

export function doEdit(data) {
  return request({
    url: '/shebeiManagement/doEdit',
    method: 'post',
    data,
  })
}

export function doDelete(data) {
  return request({
    url: '/shebeiManagement/doDelete',
    method: 'post',
    data,
  })
}
