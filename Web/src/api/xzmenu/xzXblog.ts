import {useBaseApi} from '/@/api/base';

// 星币记录接口服务
export const useXzXblogApi = () => {
	const baseApi = useBaseApi("xzXblog");
	return {
		// 分页查询星币记录
		page: baseApi.page,
		// 查看星币记录详细
		detail: baseApi.detail,
		// 新增星币记录
		add: baseApi.add,
		// 更新星币记录
		update: baseApi.update,
		// 删除星币记录
		delete: baseApi.delete,
		// 批量删除星币记录
		batchDelete: baseApi.batchDelete,
		// 导出星币记录数据
		exportData: baseApi.exportData,
		// 导入星币记录数据
		importData: baseApi.importData,
		// 下载星币记录数据导入模板
		downloadTemplate: baseApi.downloadTemplate,
	}
}

// 星币记录实体
export interface XzXblog {
	// 主键Id
	id: number;
	// 
	uid: number;
	// 
	xb: number;
	// 
	mark: string;
	// 
	xbye: number;
	// 
	createtime: string;
}