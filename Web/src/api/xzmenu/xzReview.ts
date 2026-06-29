import {useBaseApi} from '/@/api/base';

// 系统用户评测接口服务
export const useXzReviewApi = () => {
	const baseApi = useBaseApi("xzReview");
	return {
		// 分页查询系统用户评测
		page: baseApi.page,
		// 查看系统用户评测详细
		detail: baseApi.detail,
		// 新增系统用户评测
		add: baseApi.add,
		// 更新系统用户评测
		update: baseApi.update,
		// 删除系统用户评测
		delete: baseApi.delete,
		// 批量删除系统用户评测
		batchDelete: baseApi.batchDelete,
		// 导出系统用户评测数据
		exportData: baseApi.exportData,
		// 导入系统用户评测数据
		importData: baseApi.importData,
		// 下载系统用户评测数据导入模板
		downloadTemplate: baseApi.downloadTemplate,
	}
}

// 系统用户评测实体
export interface XzReview {
	// 主键Id
	id: number;
	// 
	name: string;
	// 
	tipname: string;
	// 
	img: string;
	// 
	url: string;
	// 
	money: number;
	// 
	count: number;
	// 
	sortcode: number;
	// 0：不置顶，1：置顶
	istop: number;
	// 
	rtype: number;
	// 
	click: number;
	// 
	createtime: string;
}