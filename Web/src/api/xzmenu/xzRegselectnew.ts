import {useBaseApi} from '/@/api/base';

// 注册首页选择接口服务
export const useXzRegselectnewApi = () => {
	const baseApi = useBaseApi("xzRegselectnew");
	return {
		// 分页查询注册首页选择
		page: baseApi.page,
		// 查看注册首页选择详细
		detail: baseApi.detail,
		// 新增注册首页选择
		add: baseApi.add,
		// 更新注册首页选择
		update: baseApi.update,
		// 删除注册首页选择
		delete: baseApi.delete,
		// 批量删除注册首页选择
		batchDelete: baseApi.batchDelete,
		// 导出注册首页选择数据
		exportData: baseApi.exportData,
		// 导入注册首页选择数据
		importData: baseApi.importData,
		// 下载注册首页选择数据导入模板
		downloadTemplate: baseApi.downloadTemplate,
	}
}

// 注册首页选择实体
export interface XzRegselectnew {
	// 主键Id
	id: boolean;
	// 
	uid: boolean;
	// 
	title: string;
	// 
	selectitem: string;
	// 
	createtime: string;
}