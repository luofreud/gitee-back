import {useBaseApi} from '/@/api/base';

// 用户问答接口服务
export const useXzQuestionApi = () => {
	const baseApi = useBaseApi("xzQuestion");
	return {
		// 分页查询用户问答
		page: baseApi.page,
		// 查看用户问答详细
		detail: baseApi.detail,
		// 新增用户问答
		add: baseApi.add,
		// 更新用户问答
		update: baseApi.update,
		// 删除用户问答
		delete: baseApi.delete,
		// 批量删除用户问答
		batchDelete: baseApi.batchDelete,
		// 导出用户问答数据
		exportData: baseApi.exportData,
		// 导入用户问答数据
		importData: baseApi.importData,
		// 下载用户问答数据导入模板
		downloadTemplate: baseApi.downloadTemplate,
	}
}

// 用户问答实体
export interface XzQuestion {
	// 主键Id
	id: number;
	// 
	uid: number;
	// 
	tid: number;
	// 
	name: string;
	// 
	content: string;
	// 1：星盘解读，2：测评解读
	ordertype: number;
	// 0：已完成，1：待完成
	orderstate: number;
	// 
	ftime: string;
	// 
	money: number;
	// 
	createtime: string;
	// 
	img: string;
}