import {useBaseApi} from '/@/api/base';

// 用户档案接口服务
export const useXzArchiveApi = () => {
	const baseApi = useBaseApi("xzArchive");
	return {
		// 分页查询用户档案
		page: baseApi.page,
		// 查看用户档案详细
		detail: baseApi.detail,
		// 新增用户档案
		add: baseApi.add,
		// 更新用户档案
		update: baseApi.update,
		// 删除用户档案
		delete: baseApi.delete,
		// 批量删除用户档案
		batchDelete: baseApi.batchDelete,
		// 导出用户档案数据
		exportData: baseApi.exportData,
		// 导入用户档案数据
		importData: baseApi.importData,
		// 下载用户档案数据导入模板
		downloadTemplate: baseApi.downloadTemplate,
	}
}

// 用户档案实体
export interface XzArchive {
	// 主键Id
	id: number;
	// 
	tid: number;
	// 
	name: string;
	// 
	relation: string;
	// 
	sex: number;
	// 
	birthday: string;
	// 
	address: string;
	// 
	nowaddress: string;
	// 
	createtime: string;
}