import {useBaseApi} from '/@/api/base';

// 用户投诉聊天记录接口服务
export const useXzComplaintchatApi = () => {
	const baseApi = useBaseApi("xzComplaintchat");
	return {
		// 分页查询用户投诉聊天记录
		page: baseApi.page,
		// 查看用户投诉聊天记录详细
		detail: baseApi.detail,
		// 新增用户投诉聊天记录
		add: baseApi.add,
		// 更新用户投诉聊天记录
		update: baseApi.update,
		// 删除用户投诉聊天记录
		delete: baseApi.delete,
		// 批量删除用户投诉聊天记录
		batchDelete: baseApi.batchDelete,
		// 导出用户投诉聊天记录数据
		exportData: baseApi.exportData,
		// 导入用户投诉聊天记录数据
		importData: baseApi.importData,
		// 下载用户投诉聊天记录数据导入模板
		downloadTemplate: baseApi.downloadTemplate,
	}
}

// 用户投诉聊天记录实体
export interface XzComplaintchat {
	// 主键Id
	id: number;
	// 
	cid: number;
	// 
	uid: number;
	// 0:用户发送，1：系统发送
	direction: number;
	// 
	content: string;
	// 
	createtime: string;
}