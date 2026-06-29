import {useBaseApi} from '/@/api/base';

// 星座咨询师接口服务
export const useXzTeacherApi = () => {
	const baseApi = useBaseApi("xzTeacher");
	return {
		// 分页查询星座咨询师
		page: baseApi.page,
		// 查看星座咨询师详细
		detail: baseApi.detail,
		// 新增星座咨询师
		add: baseApi.add,
		// 更新星座咨询师
		update: baseApi.update,
		// 删除星座咨询师
		delete: baseApi.delete,
		// 批量删除星座咨询师
		batchDelete: baseApi.batchDelete,
		// 导出星座咨询师数据
		exportData: baseApi.exportData,
		// 导入星座咨询师数据
		importData: baseApi.importData,
		// 下载星座咨询师数据导入模板
		downloadTemplate: baseApi.downloadTemplate,
	}
}

// 星座咨询师实体
export interface XzTeacher {
	// 主键Id
	id: number;
	// 姓名
	name: string;
	// 头像
	headimg: string;
	// 等级
	level: number;
	// 推广code
	tgcode: string;
	// 介绍
	introduction: string;
	// 
	score: number;
	// 星钻
	xzmoney: number;
	// 从业年限
	year: number;
	// 标签
	tags: string;
	// 0：在线，1：离线
	livestate: number;
	// 0：正常，1：审核中
	state: number;
	// 电话
	phone: string;
	// 身份证照片
	card: string;
	// 银行卡照片
	bankcard: string;
	// 银行卡编号
	banknum: string;
	// 开户行
	bankname: string;
	// 开户行名称
	bankaddress: string;
	// 越大越靠前
	sortcode: number;
	// 0：不推荐，1：推荐
	istop: number;
	// 入住时间，审核成功修改时间
	checktime: string;
	// 
	createtime: string;
}