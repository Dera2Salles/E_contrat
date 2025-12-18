import 'package:e_contrat/features/pdf_management/data/datasources/pdf_local_datasource.dart';
import 'package:e_contrat/features/pdf_management/data/repositories/pdf_repository_impl.dart';
import 'package:e_contrat/features/pdf_management/domain/repositories/pdf_repository.dart';
import 'package:e_contrat/features/pdf_management/domain/usecases/delete_pdf.dart';
import 'package:e_contrat/features/pdf_management/domain/usecases/get_all_pdfs.dart';
import 'package:e_contrat/features/pdf_management/domain/usecases/save_pdf_bytes.dart';
import 'package:e_contrat/features/contract/data/datasources/contract_templates_static_datasource.dart';
import 'package:e_contrat/features/contract/data/repositories/contract_templates_repository_impl.dart';
import 'package:e_contrat/features/contract/domain/repositories/contract_templates_repository.dart';
import 'package:e_contrat/features/contract/domain/usecases/get_contract_categories.dart';
import 'package:e_contrat/features/pdf_management/presentation/bloc/pdf_list_bloc.dart';
import 'package:e_contrat/features/contract/presentation/bloc/contract_categories_bloc.dart';
import 'package:e_contrat/features/assistant/data/datasources/assistant_local_datasource.dart';
import 'package:e_contrat/features/assistant/data/datasources/assistant_remote_datasource.dart';
import 'package:e_contrat/features/assistant/data/repositories/assistant_repository_impl.dart';
import 'package:e_contrat/features/assistant/domain/repositories/assistant_repository.dart';
import 'package:e_contrat/features/assistant/domain/usecases/assistant_usecases.dart';
import 'package:e_contrat/features/assistant/presentation/bloc/assistant_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:e_contrat/core/di/injection.config.dart';

export 'injection.config.dart';


final getIt = GetIt.instance;

@module
class RegisterModule {
}

@injectableInit
void configureDependencies() => $initGetIt(getIt);

void registerFeatureDependencies() {
  // PDF Management
  if (!getIt.isRegistered<PdfLocalDataSource>()) {
    getIt.registerLazySingleton<PdfLocalDataSource>(() => PdfLocalDataSource());
  }

  if (!getIt.isRegistered<PdfRepository>()) {
    getIt.registerLazySingleton<PdfRepository>(
      () => PdfRepositoryImpl(getIt<PdfLocalDataSource>()),
    );
  }

  if (!getIt.isRegistered<GetAllPdfs>()) {
    getIt.registerFactory<GetAllPdfs>(() => GetAllPdfs(getIt<PdfRepository>()));
  }

  if (!getIt.isRegistered<DeletePdf>()) {
    getIt.registerFactory<DeletePdf>(() => DeletePdf(getIt<PdfRepository>()));
  }

  if (!getIt.isRegistered<SavePdfBytes>()) {
    getIt.registerFactory<SavePdfBytes>(() => SavePdfBytes(getIt<PdfRepository>()));
  }

  if (!getIt.isRegistered<PdfListBloc>()) {
    getIt.registerFactory<PdfListBloc>(
      () => PdfListBloc(getAllPdfs: getIt<GetAllPdfs>(), deletePdf: getIt<DeletePdf>()),
    );
  }

  // Contract Templates
  if (!getIt.isRegistered<ContractTemplatesStaticDataSource>()) {
    getIt.registerLazySingleton<ContractTemplatesStaticDataSource>(
      () => const ContractTemplatesStaticDataSource(),
    );
  }

  if (!getIt.isRegistered<ContractTemplatesRepository>()) {
    getIt.registerLazySingleton<ContractTemplatesRepository>(
      () => ContractTemplatesRepositoryImpl(getIt<ContractTemplatesStaticDataSource>()),
    );
  }

  if (!getIt.isRegistered<GetContractCategories>()) {
    getIt.registerFactory<GetContractCategories>(
      () => GetContractCategories(getIt<ContractTemplatesRepository>()),
    );
  }

  if (!getIt.isRegistered<ContractCategoriesBloc>()) {
    getIt.registerFactory<ContractCategoriesBloc>(
      () => ContractCategoriesBloc(getContractCategories: getIt<GetContractCategories>()),
    );
  }

  // Assistant
  if (!getIt.isRegistered<AssistantLocalDataSource>()) {
    getIt.registerLazySingleton<AssistantLocalDataSource>(() => AssistantLocalDataSourceImpl());
  }

  if (!getIt.isRegistered<AssistantRemoteDataSource>()) {
    getIt.registerLazySingleton<AssistantRemoteDataSource>(() => AssistantRemoteDataSourceImpl());
  }

  if (!getIt.isRegistered<AssistantRepository>()) {
    getIt.registerLazySingleton<AssistantRepository>(
      () => AssistantRepositoryImpl(
        localDataSource: getIt<AssistantLocalDataSource>(),
        remoteDataSource: getIt<AssistantRemoteDataSource>(),
      ),
    );
  }

  if (!getIt.isRegistered<GetConversations>()) {
    getIt.registerFactory(() => GetConversations(getIt<AssistantRepository>()));
  }
  if (!getIt.isRegistered<CreateConversation>()) {
    getIt.registerFactory(() => CreateConversation(getIt<AssistantRepository>()));
  }
  if (!getIt.isRegistered<DeleteConversation>()) {
    getIt.registerFactory(() => DeleteConversation(getIt<AssistantRepository>()));
  }
  if (!getIt.isRegistered<GetMessages>()) {
    getIt.registerFactory(() => GetMessages(getIt<AssistantRepository>()));
  }
  if (!getIt.isRegistered<SendMessage>()) {
    getIt.registerFactory(() => SendMessage(getIt<AssistantRepository>()));
  }
  if (!getIt.isRegistered<SaveMessage>()) {
    getIt.registerFactory(() => SaveMessage(getIt<AssistantRepository>()));
  }
  if (!getIt.isRegistered<UpdateConversationTitle>()) {
    getIt.registerFactory(() => UpdateConversationTitle(getIt<AssistantRepository>()));
  }

  if (!getIt.isRegistered<AssistantBloc>()) {
    getIt.registerFactory(
      () => AssistantBloc(
        getConversations: getIt<GetConversations>(),
        createConversation: getIt<CreateConversation>(),
        deleteConversation: getIt<DeleteConversation>(),
        getMessages: getIt<GetMessages>(),
        sendMessage: getIt<SendMessage>(),
        saveMessage: getIt<SaveMessage>(),
        updateConversationTitle: getIt<UpdateConversationTitle>(),
      ),
    );
  }
}
