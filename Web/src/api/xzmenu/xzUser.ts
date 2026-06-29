import {useBaseApi} from '/@/api/base';

// 用户信息接口服务
export const useXzUserApi = () => {
	const baseApi = useBaseApi("xzUser");
	return {
		// 分页查询用户信息
		page: baseApi.page,
		// 查看用户信息详细
		detail: baseApi.detail,
		// 新增用户信息
		add: baseApi.add,
		// 更新用户信息
		update: baseApi.update,
		// 删除用户信息
		delete: baseApi.delete,
		// 批量删除用户信息
		batchDelete: baseApi.batchDelete,
		// 导出用户信息数据
		exportData: baseApi.exportData,
		// 导入用户信息数据
		importData: baseApi.importData,
		// 下载用户信息数据导入模板
		downloadTemplate: baseApi.downloadTemplate,
	}
}

// 用户信息实体
export interface XzUser {
	// 主键Id
	id: number;
	// 昵称
	nickname: string;
	// 电话
	phone: string;
	// openid
	openid: string;
	// 0:男，1:女
	sex: number;
	// 等级1-5
	level: number;
	// 出生地址
	address: string;
	// 头像
	headimg: string;
	// 现居地址
	nowaddress: string;
	// 星币
	xbmoney: number;
	// 星钻 1-1
	xzmoney: number;
	// 连麦时长（剩余）
	lmtime: number;
	// 是否首充
	iscz: number;
	// 签名限定20个字
	sign: string;
	// 0：正常，1：异常
	state: number;
	// 
	tgcode: string;
	// 
	createtime: string;
}