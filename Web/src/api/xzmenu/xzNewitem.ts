import {useBaseApi} from '/@/api/base';

// 内容的标签接口服务
export const useXzNewitemApi = () => {
	const baseApi = useBaseApi("xzNewitem");
	return {
		// 分页查询内容的标签
		page: baseApi.page,
		// 查看内容的标签详细
		detail: baseApi.detail,
		// 新增内容的标签
		add: baseApi.add,
		// 更新内容的标签
		update: baseApi.update,
		// 删除内容的标签
		delete: baseApi.delete,
		// 批量删除内容的标签
		batchDelete: baseApi.batchDelete,
		// 导出内容的标签数据
		exportData: baseApi.exportData,
		// 导入内容的标签数据
		importData: baseApi.importData,
		// 下载内容的标签数据导入模板
		downloadTemplate: baseApi.downloadTemplate,
	}
}

// 内容的标签实体
export interface XzNewitem {
	// 主键Id
	id: boolean;
	// 
	newid: boolean;
	// 
	title: string;
	// 
	seotitle: string;
	// 
	sortcode: number;
	// 
	createtime: string;
}