import {useBaseApi} from '/@/api/base';

// 用户投诉记录表接口服务
export const useXzComplaintlogApi = () => {
	const baseApi = useBaseApi("xzComplaintlog");
	return {
		// 分页查询用户投诉记录表
		page: baseApi.page,
		// 查看用户投诉记录表详细
		detail: baseApi.detail,
		// 新增用户投诉记录表
		add: baseApi.add,
		// 更新用户投诉记录表
		update: baseApi.update,
		// 删除用户投诉记录表
		delete: baseApi.delete,
		// 批量删除用户投诉记录表
		batchDelete: baseApi.batchDelete,
		// 导出用户投诉记录表数据
		exportData: baseApi.exportData,
		// 导入用户投诉记录表数据
		importData: baseApi.importData,
		// 下载用户投诉记录表数据导入模板
		downloadTemplate: baseApi.downloadTemplate,
	}
}

// 用户投诉记录表实体
export interface XzComplaintlog {
	// 主键Id
	id: number;
	// 
	uid: number;
	// 
	cnum: string;
	// 0：连麦，1：咨询师，2：
	ctype: number;
	// 关联id，后期可以单独拆成单独投诉表
	relevanceid: number;
	// 结束时间
	overtime: string;
	// 0：正在投诉中，1：完成
	cstate: number;
	// 投诉内容描述
	content: string;
	// 投诉截图
	imgs: string;
	// 
	createtime: string;
}